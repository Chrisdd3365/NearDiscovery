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
    @IBOutlet var placeDetailsView: PlaceDetailsView!
    
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
        setPlaceDetailsUI()
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
    
    private func setPlaceDetailsUI() {
        placeDetailsView.placeDetailsViewConfigure = placeDetails
        placeDetailsView.placeDetailsImageConfigure(photoReference: place.photos?[0].photoReference ?? "")
    }
}

//MARK: - List's updates setup methods
extension PlaceDetailsViewController {
    private func addToLocationListSetup() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        let tabItem = tabItems[1]
        
        if checkLocationList() == false {
            CoreDataManager.saveLocation(placeDetails: placeDetails, place: place)
            tabItem.badgeValue = "New"
            locations = Location.all
        } else {
            locations = Location.all
            showAlert(title: "Error", message: "You already add this location in your location list!")
            tabItem.badgeValue = nil
        }
    }
    
    private func checkLocationList() -> Bool {
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

