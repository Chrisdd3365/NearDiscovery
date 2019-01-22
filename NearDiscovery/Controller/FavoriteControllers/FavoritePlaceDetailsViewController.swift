//
//  FavoritePlaceDetailsViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 20/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class FavoritePlaceDetailsViewController: UIViewController {

    @IBOutlet weak var favoritePlaceDetailsTableView: UITableView!
    
    var detailedFavoritePlace: Favorite?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritePlaceDetailsTableView.allowsSelection = false
        favoritePlaceDetailsTableView.tableFooterView = UIView()
        setNavigationItemTitle(title: "Favorite Place's Details")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showFavoriteLocationOnMapSegue,
            let favoriteMapVC = segue.destination as? FavoriteMapViewController {
            favoriteMapVC.favoritePlace = detailedFavoritePlace
        }
    }
}

extension FavoritePlaceDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = favoritePlaceDetailsTableView.dequeueReusableCell(withIdentifier: FavoritePlaceDetailsImageTableViewCell.identifier, for: indexPath) as? FavoritePlaceDetailsImageTableViewCell else {
                return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.placeDetailsImageCellConfigure(favoritePlace: detailedFavoritePlace)
        case 1:
            guard let cell = favoritePlaceDetailsTableView.dequeueReusableCell(withIdentifier: FavoritePlaceNameAddressRatingTableViewCell.identifier, for: indexPath) as? FavoritePlaceNameAddressRatingTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.nameAddressRatingLabelsCellConfigure(favoritePlaceDetails: detailedFavoritePlace)
        case 2:
            guard let cell = favoritePlaceDetailsTableView.dequeueReusableCell(withIdentifier: FavoritePlaceCallShareFavoriteWebsiteTableViewCell.identifier, for: indexPath) as? FavoritePlaceCallShareFavoriteWebsiteTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.delegate = self
        case 3:
            guard let cell = favoritePlaceDetailsTableView.dequeueReusableCell(withIdentifier: FavoritePlaceDiscoverMarkedLocationTableViewCell.identifier, for: indexPath) as? FavoritePlaceDiscoverMarkedLocationTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.discoverLabelConfigure()
        case 4:
            guard let cell = favoritePlaceDetailsTableView.dequeueReusableCell(withIdentifier: FavoritePlaceScheduleTableViewCell.identifier, for: indexPath) as? FavoritePlaceScheduleTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.scheduleOpenStateCellConfigure(favoritePlaceDetails: detailedFavoritePlace)
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

extension FavoritePlaceDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0 :
            return 130
        case 1:
            return 92
        case 2:
            return 91
        case 3:
            return 120
        case 4:
            return 110
        default:
            return 0
        }
    }
}

extension FavoritePlaceDetailsViewController: FavoriteDetailsButtonsActionsDelegate {
    func cleanPhoneNumberConverted(phoneNumber: String?) -> String {
        let phoneNumber = String(describing: phoneNumber ?? "0000000000")
        let phoneNumberConverted = phoneNumber.replacingOccurrences(of: " ", with: "")
        return phoneNumberConverted
    }
    
    func didTapCallButton() {
        let phoneNumber = cleanPhoneNumberConverted(phoneNumber: detailedFavoritePlace?.phoneNumber)
        let phoneURL = URL(string: ("tel://\(phoneNumber)"))
        if let phoneURL = phoneURL {
            print(phoneURL)
            UIApplication.shared.open(phoneURL)
        }
    }
    
    func didTapShareButton() {
        let urlString =  detailedFavoritePlace?.url
        if let urlString = urlString {
            let activityController = UIActivityViewController(activityItems: ["Hey! Check out this place!", urlString], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        } else {
            showAlert(title: "Sorry", message: "No website to share for this place!")
        }
    }
    
    func didTapFavoriteButton() {
        CoreDataManager.deleteFavoriteFromList(placeId: detailedFavoritePlace?.placeId ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    func didTapWebsiteButton() {
        if let detailedFavoritePlace = detailedFavoritePlace {
            guard let url = URL(string: detailedFavoritePlace.website ?? "") else { return }
            UIApplication.shared.open(url)
        } else {
            showAlert(title: "Sorry", message: "No website available for this place!")
        }
    }
}
