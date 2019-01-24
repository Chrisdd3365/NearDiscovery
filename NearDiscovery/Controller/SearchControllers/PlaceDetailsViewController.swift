//
//  PlaceDetailsViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    //MARK: - Outlet:
    @IBOutlet weak var placeDetailsScrollView: PlaceDetailsScrollView!
    
    //MARK - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var place: PlaceSearch?
    var placeDetails: PlaceDetails?
    var locations = Location.all
    var favorites = Favorite.all
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItemTitle(title: "Place's Details")
        placeDetailsScrollViewConfigure(placeDetails: placeDetails, place: place)
        placeDetailsScrollView.favoriteButton.setImage(updateFavoriteButtonImage(), for: .normal)
        placeDetailsScrollView.markedLocationButton.setImage(updateMarkedLocationImage(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locations = Location.all
        favorites = Favorite.all
        placeDetailsScrollView.favoriteButton.setImage(updateFavoriteButtonImage(), for: .normal)
        placeDetailsScrollView.markedLocationButton.setImage(updateMarkedLocationImage(), for: .normal)
    }
    
    //MARK: - Actions
    @IBAction func phoneCall(_ sender: UIButton) {
        didTapCallButton()
    }
    
    @IBAction func share(_ sender: UIButton) {
        didTapShareButton()
    }
    
    @IBAction func addToFavoriteList(_ sender: UIButton) {
        addToFavoriteListSetup()
    }
    
    @IBAction func showWebsite(_ sender: UIButton) {
        didTapWebsiteButton()
    }
    
    @IBAction func addToLocationList(_ sender: UIButton) {
        addToLocationListSetup()
    }
    
    //MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showLocationOnMapSegue,
            let mapVC = segue.destination as? MapViewController {
            mapVC.placeDetails = placeDetails
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    private func placeDetailsScrollViewConfigure(placeDetails: PlaceDetails?, place: PlaceSearch?) {
        placeDetailsScrollView.placeDetailsScrollViewConfigure = placeDetails
        placeDetailsScrollView.placeDetailsImageCellConfigure(place: place)
    }
    
    func cleanPhoneNumberConverted(phoneNumber: String?) -> String {
        let phoneNumber = String(describing: phoneNumber ?? "0000000000")
        let phoneNumberConverted = phoneNumber.replacingOccurrences(of: " ", with: "")
        return phoneNumberConverted
    }
    
    func didTapCallButton() {
        let phoneNumber = cleanPhoneNumberConverted(phoneNumber: placeDetails?.internationalPhoneNumber)
        let phoneURL = URL(string: ("tel://\(phoneNumber)"))
        if let phoneURL = phoneURL {
            print(phoneURL)
            UIApplication.shared.open(phoneURL)
        }
    }
    
    func didTapShareButton() {
        let urlString =  placeDetails?.url
        if let urlString = urlString {
            let activityController = UIActivityViewController(activityItems: ["Hey! Check out this place!", urlString], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        } else {
            showAlert(title: "Sorry!", message: "I have no Google Maps Link for you to share!")
        }
    }
    
    func didUpdateFavoriteButtonImage() -> UIImage {
        return updateFavoriteButtonImage()
    }
    
    func didTapWebsiteButton() {
        if let placeDetails = placeDetails {
            guard let url = URL(string: placeDetails.website ?? "") else { return }
            UIApplication.shared.open(url)
        } else {
            showAlert(title: "Sorry!", message: "I have no Website to show you!")
        }
    }
}

//MARK: - List's updates setup methods
extension PlaceDetailsViewController {
    //MARK: - Location's List
    private func addToLocationListSetup() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        
        let tabItem = tabItems[1]
        
        guard let value = Int(tabItem.badgeValue ?? "0") else { return }
        
        if checkMarkedLocation() == false {
            if locations.count < 10 {
                guard let placeDetails = placeDetails else { return }
                placeDetailsScrollView.markedLocationButton.setImage(UIImage(named: "markedLocation"), for: .normal)

                CoreDataManager.saveLocation(placeDetails: placeDetails, place: place)
                tabItem.badgeValue = String(value + 1)
                locations = Location.all
                
            } else {
                showAlert(title: "Sorry!", message: "You've reached the maximum amount of Marked Locations!")
                tabItem.badgeValue = nil
            }
        } else {
            locations = Location.all
            showAlert(title: "Sorry!", message: "You've already marked this location on the map!")
            tabItem.badgeValue = nil
        }
    }

    private func checkMarkedLocation() -> Bool {
        var isAdded = false
        guard locations.count != 0 else { return false }
        for location in locations {
            if placeDetails?.placeId == location.placeId {
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
    
    //MARK: - Favorite's List
    private func addToFavoriteListSetup() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        
        let tabItem = tabItems[2]
        
        guard let value = Int(tabItem.badgeValue ?? "0") else { return }
        
        if checkFavoritePlace() == false {
            guard let placeDetails = placeDetails else { return }
            placeDetailsScrollView.favoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
            CoreDataManager.saveFavorite(placeDetails: placeDetails, place: place)
            tabItem.badgeValue = String(value + 1)
            favorites = Favorite.all
        } else {
            favorites = Favorite.all
            showAlert(title: "Sorry!", message: "You've already added this place into the favorite list!")
            tabItem.badgeValue = nil
        }
    }

    private func checkFavoritePlace() -> Bool {
        var isAdded = false
        guard favorites.count != 0 else { return false }
        for favorite in favorites {
            if placeDetails?.placeId == favorite.placeId {
                isAdded = true
                break
            }
        }
        return isAdded
    }
    //Method to update the favorite button image
    private func updateFavoriteButtonImage() -> UIImage {
        var image: UIImage!
        if checkFavoritePlace() {
            image = UIImage(named: "favorite")
        } else {
            image = UIImage(named: "noFavorite")
        }
        return image
    }
}
