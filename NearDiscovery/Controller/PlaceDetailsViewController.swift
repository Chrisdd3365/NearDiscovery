//
//  PlaceDetailsViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var placeDetailsTableView: UITableView!
    
    //MARK - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var place: PlaceSearch!
    var placeDetails: PlaceDetails!
    var location: Location?
    var locations = Location.all
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItemTitle()
        placeDetailsTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locations = Location.all
    }
    
    //MARK: - Actions
    @IBAction func showWebsite(_ sender: UIButton) {
        if let placeDetails = placeDetails {
            guard let url = URL(string: placeDetails.website ?? "") else { return }
            UIApplication.shared.open(url)
        } else {
            showAlert(title: "Error", message: "Failed to get you to the website. Try again!")
        }
    }
    
    @IBAction func addLocationOnMap(_ sender: UIButton) {
        addToLocationListSetup()
        showAlert(title: "Success", message: "Location has been added successfully!")
    }
    
    //MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showLocationOnMapSegue,
            let mapVC = segue.destination as? MapViewController {
            mapVC.placeDetails = placeDetails
        }
    }
}

//MARK: - UI's setup methods
extension PlaceDetailsViewController {
    private func setNavigationItemTitle() {
        navigationItem.title = "Place's Details"
    }
}

//MARK: - List's updates setup methods
extension PlaceDetailsViewController {
    private func addToLocationListSetup() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        let tabItem = tabItems[1]
        
        if checkLocationsList() == false {
            CoreDataManager.saveLocation(placeDetails: placeDetails, place: place)
            tabItem.badgeValue = "New"
            locations = Location.all
        } else {
            locations = Location.all
            showAlert(title: "Error", message: "You already add this location in your location list!")
            tabItem.badgeValue = nil
        }
    }
    
    private func checkLocationsList() -> Bool {
        var isAdded = false
        guard locations.count != 0 else { return false }
        for location in locations {
            if placeDetails.placeId == location.placeId {
                isAdded = true
                break
            }
        }
        return isAdded
    }
}

extension PlaceDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = placeDetailsTableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as? ImageTableViewCell else {
                return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.placeDetailsImageCellConfigure(place: place)
        case 1:
            guard let cell = placeDetailsTableView.dequeueReusableCell(withIdentifier: NameAdressRatingLabelsTableViewCell.identifier, for: indexPath) as? NameAdressRatingLabelsTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.nameAddressRatingLabelsCellConfigure(placeDetails: placeDetails)
        case 2:
            guard let cell = placeDetailsTableView.dequeueReusableCell(withIdentifier: ScheduleTextViewOpenStateLabelTableViewCell.identifier, for: indexPath) as? ScheduleTextViewOpenStateLabelTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.scheduleOpenStateCellConfigure(placeDetails: placeDetails)
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

extension PlaceDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0 :
            return 130
        case 1:
            return 92
        case 2:
            return 110
        default:
            return 0
        }
    }
}
