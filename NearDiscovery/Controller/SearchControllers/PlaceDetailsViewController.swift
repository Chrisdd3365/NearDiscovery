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
        buttonsSetImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locations = Location.all
        favorites = Favorite.all
        buttonsSetImage()
    }
    
    //MARK: - Actions
    @IBAction func phoneCall(_ sender: UIButton) {
        didTapCallButton(phoneNumber: placeDetails?.internationalPhoneNumber ?? "0000000000")
    }
    
    @IBAction func share(_ sender: UIButton) {
        didTapShareButton(url: placeDetails?.url)
    }
    
    @IBAction func addToFavoriteList(_ sender: UIButton) {
        addToFavoriteListSetup()
    }
    
    @IBAction func showWebsite(_ sender: UIButton) {
        didTapWebsiteButton(website: placeDetails?.website)
    }
    
    @IBAction func addToLocationList(_ sender: UIButton) {
        addToLocationListSetup()
    }
    
    //MARK: - Methods
    private func buttonsSetImage() {
        placeDetailsScrollView.favoriteButton.setImage(updateButtonImage(check: checkFavoritePlace(favorites: favorites, placeDetailsPlaceId: placeDetails?.placeId ?? ""), checkedImage: "favorite", uncheckedImage: "noFavorite"), for: .normal)
        placeDetailsScrollView.markedLocationButton.setImage(updateButtonImage(check: checkMarkedLocation(locations: locations, placeDetailsPlaceId: placeDetails?.placeId ?? ""), checkedImage: "markedLocation", uncheckedImage: "noMarkedLocation"), for: .normal)
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

//MARK: - List's updates setup methods
extension PlaceDetailsViewController {
    //MARK: - Location's List
    private func addToLocationListSetup() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        
        let tabItem = tabItems[1]
        
        guard let value = Int(tabItem.badgeValue ?? "0") else { return }
        
        if checkMarkedLocation(locations: locations, placeDetailsPlaceId: placeDetails?.placeId ?? "") == false {
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

    //MARK: - Favorite's List
    private func addToFavoriteListSetup() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        
        let tabItem = tabItems[2]
        
        guard let value = Int(tabItem.badgeValue ?? "0") else { return }
        
        if checkFavoritePlace(favorites: favorites, placeDetailsPlaceId: placeDetails?.placeId ?? "") == false {
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
}
