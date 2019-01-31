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
        setNavigationItemTitle(title: "Favorite Place's Details".localized())
        favoritePlaceDetailsScrollViewConfigure(favoritePlace: detailedFavoritePlace)
        markedLocationButtonSetImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locations = Location.all
        markedLocationButtonSetImage()
    }
    
    //MARK: - Actions
    @IBAction func phoneCall(_ sender: UIButton) {
        didTapCallButton(phoneNumber: detailedFavoritePlace?.phoneNumber ?? "0000000000")
    }
    
    @IBAction func share(_ sender: UIButton) {
        didTapShareButton(url: detailedFavoritePlace?.url)
    }
    
    @IBAction func removeFromFavorite(_ sender: UIButton) {
        didTapFavoriteButton(placeId: detailedFavoritePlace?.placeId)
    }
    
    @IBAction func showWebsite(_ sender: UIButton) {
        didTapWebsiteButton(website: detailedFavoritePlace?.website)
    }
    
    @IBAction func markedLocation(_ sender: UIButton) {
        addToLocationListSetup()
    }
    
    //MARK: - Method
    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showFavoriteLocationOnMapSegue,
            let mapVC = segue.destination as? MapViewController {
            mapVC.favoritePlace = detailedFavoritePlace
        }
    }
}

//MARK: - Setup UI methods
extension FavoritePlaceDetailsViewController {
    //Setup Marked Location Image
    private func markedLocationButtonSetImage() {
        favoritePlaceDetailsScrollView.markedLocationButton.setImage(updateButtonImage(check: checkMarkedLocation(locations: locations, placeDetailsPlaceId: detailedFavoritePlace?.placeId ?? "") , checkedImage: "markedLocation", uncheckedImage: "noMarkedLocation"), for: .normal)
    }
    
    //Setup ScrollView
    private func favoritePlaceDetailsScrollViewConfigure(favoritePlace: Favorite?) {
        favoritePlaceDetailsScrollView.favoritePlaceScrollViewConfigure = favoritePlace
        favoritePlaceDetailsScrollView.favoritePlaceImageCellConfigure(favoritePlace: favoritePlace)
    }
}

//MARK: - Location's List methods
extension FavoritePlaceDetailsViewController {
    private func addToLocationListSetup() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        
        let tabItem = tabItems[1]
        
        guard let value = Int(tabItem.badgeValue ?? "0") else { return }
        
        if checkMarkedLocation(locations: locations, placeDetailsPlaceId: detailedFavoritePlace?.placeId ?? "") == false {
            if locations.count < 5 {
                guard let detailedFavoritePlace = detailedFavoritePlace else { return }
                favoritePlaceDetailsScrollView.markedLocationButton.setImage(UIImage(named: "markedLocation"), for: .normal)
                CoreDataManager.saveLocationFromFavorite(favoritePlace: detailedFavoritePlace)
                tabItem.badgeValue = String(value + 1)
                locations = Location.all
                
            } else {
                showAlert(title: "Sorry!".localized(), message: "You've reached the maximum amount of Marked Locations!".localized())
                tabItem.badgeValue = nil
            }
        } else {
            locations = Location.all
            showAlert(title: "Sorry".localized(), message: "You've already marked this location on the map!".localized())
            tabItem.badgeValue = nil
        }
    }
}

