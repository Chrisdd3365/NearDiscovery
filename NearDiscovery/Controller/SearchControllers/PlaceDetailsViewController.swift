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
    
    //MARK: - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var place: PlaceSearch?
    var placeDetails: PlaceDetails?
    var locations = Location.all
    var favorites = Favorite.all
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItemTitle(title: "Place's Details".localized())
        placeDetailsScrollViewConfigure(placeDetails: placeDetails, place: place)
        buttonSetImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locations = Location.all
        favorites = Favorite.all
        buttonSetImage()
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
    private func buttonSetImage() {
        placeDetailsScrollView.favoriteButton.setImage(updateFavoriteButtonImage(), for: .normal)
        placeDetailsScrollView.markedLocationButton.setImage(updateMarkedLocationImage(), for: .normal)
    }
    
    //Setup ScrollView
    private func placeDetailsScrollViewConfigure(placeDetails: PlaceDetails?, place: PlaceSearch?) {
        placeDetailsScrollView.placeDetailsScrollViewConfigure = placeDetails
        placeDetailsScrollView.placeDetailsImageCellConfigure(place: place)
    }
    
    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showLocationOnMapSegue,
            let mapVC = segue.destination as? MapViewController {
            mapVC.placeDetails = placeDetails
            let backItem = UIBarButtonItem()
            backItem.title = "Back".localized()
            navigationItem.backBarButtonItem = backItem
        }
    }
}

//MARK: - Call/Share/Favorite/Website methods
extension PlaceDetailsViewController {
    //Helper's method for Call
    func cleanPhoneNumberConverted(phoneNumber: String?) -> String {
        let phoneNumber = String(describing: phoneNumber ?? "0000000000")
        let phoneNumberConverted = phoneNumber.replacingOccurrences(of: " ", with: "")
        return phoneNumberConverted
    }
    
    //Call
    func didTapCallButton() {
        let phoneNumber = cleanPhoneNumberConverted(phoneNumber: placeDetails?.internationalPhoneNumber)
        let phoneURL = URL(string: ("tel://\(phoneNumber)"))
        if let phoneURL = phoneURL {
            UIApplication.shared.open(phoneURL)
        }
    }
    
    //Share
    func didTapShareButton() {
        let urlString =  placeDetails?.url
        if let urlString = urlString {
            let activityController = UIActivityViewController(activityItems: ["Hey! Check out this place!".localized(), urlString], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        } else {
            showAlert(title: "Sorry!".localized(), message: "I have no Google Maps Link for you to share!".localized())
        }
    }
    
    //Favorite
    func didUpdateFavoriteButtonImage() -> UIImage {
        return updateFavoriteButtonImage()
    }
    
    //Website
    func didTapWebsiteButton() {
        if let placeDetails = placeDetails {
            guard let url = URL(string: placeDetails.website ?? "") else { return }
            UIApplication.shared.open(url)
        } else {
            showAlert(title: "Sorry!".localized(), message: "I have no Website to show you!".localized())
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
            if locations.count < 5 {
                guard let placeDetails = placeDetails else { return }
                placeDetailsScrollView.markedLocationButton.setImage(UIImage(named: "markedLocation"), for: .normal)

                CoreDataManager.saveLocation(placeDetails: placeDetails, place: place)
                tabItem.badgeValue = String(value + 1)
                locations = Location.all
                
            } else {
                showAlert(title: "Sorry!".localized(), message: "You've reached the maximum amount of Marked Locations!".localized())
                tabItem.badgeValue = nil
            }
        } else {
            locations = Location.all
            showAlert(title: "Sorry!".localized(), message: "You've already marked this location on the map!".localized())
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
            showAlert(title: "Sorry!".localized(), message: "You've already added this place into the favorite list!".localized())
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
