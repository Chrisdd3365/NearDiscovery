//
//  FavoritePlaceDetailsViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 20/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class FavoritePlaceDetailsViewController: UIViewController {
    //MARK: - Outlet:
    @IBOutlet weak var favoritePlaceDetailsScrollView: FavoritePlaceDetailsScrollView!
    
    //MARK: - Property:
    var detailedFavoritePlace: Favorite?
    var locations = Location.all
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItemTitle(title: "Favorite Place's Details")
        favoritePlaceDetailsScrollViewConfigure(favoritePlace: detailedFavoritePlace)
        favoritePlaceDetailsScrollView.markedLocationButton.setImage(updateMarkedLocationImage(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        locations = Location.all
        favoritePlaceDetailsScrollView.markedLocationButton.setImage(updateMarkedLocationImage(), for: .normal)
    }
    
    //MARK: - Actions
    @IBAction func phoneCall(_ sender: UIButton) {
        didTapCallButton()
    }
    
    @IBAction func share(_ sender: UIButton) {
        didTapShareButton()
    }
    
    @IBAction func removeFromFavorite(_ sender: UIButton) {
        didTapFavoriteButton()
    }
    
    @IBAction func showWebsite(_ sender: UIButton) {
        didTapWebsiteButton()
    }
    
    @IBAction func markedLocation(_ sender: UIButton) {
        addToLocationListSetup()
    }
    
    //MARK: - Location's List
    private func addToLocationListSetup() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        
        let tabItem = tabItems[1]
        
        guard let value = Int(tabItem.badgeValue ?? "0") else { return }
        
        if checkMarkedLocation() == false {
            if locations.count < 10 {
                guard let detailedFavoritePlace = detailedFavoritePlace else { return }
                favoritePlaceDetailsScrollView.markedLocationButton.setImage(UIImage(named: "markedLocation"), for: .normal)
                CoreDataManager.saveLocationFromFavorite(favoritePlace: detailedFavoritePlace)
                tabItem.badgeValue = String(value + 1)
                locations = Location.all
                
            } else {
                showAlert(title: "Sorry", message: "Maximum reached!")
                tabItem.badgeValue = nil
            }
        } else {
            locations = Location.all
            showAlert(title: "Sorry", message: "You already add this location into the list!")
            tabItem.badgeValue = nil
        }
    }
    
    private func checkMarkedLocation() -> Bool {
        var isAdded = false
        guard locations.count != 0 else { return false }
        for location in locations {
            if detailedFavoritePlace?.placeId == location.placeId {
                isAdded = true
                break
            }
        }
        return isAdded
    }
    
    private func updateMarkedLocationImage() -> UIImage {
        var image: UIImage!
        if checkMarkedLocation() {
            image = UIImage(named: "markedLocation")
        } else {
            image = UIImage(named: "noMarkedLocation")
        }
        return image
    }
    
    
    //MARK: - Methods
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
    
    private func favoritePlaceDetailsScrollViewConfigure(favoritePlace: Favorite?) {
        favoritePlaceDetailsScrollView.favoritePlaceScrollViewConfigure = favoritePlace
        favoritePlaceDetailsScrollView.favoritePlaceImageCellConfigure(favoritePlace: favoritePlace)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showFavoriteLocationOnMapSegue,
            let favoriteMapVC = segue.destination as? FavoriteMapViewController {
            favoriteMapVC.favoritePlace = detailedFavoritePlace
        }
    }
}



