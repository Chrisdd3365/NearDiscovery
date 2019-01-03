//
//  PlaceDetailsViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    var place: PlaceSearch!
    var placeDetails: PlaceDetails!
    
    @IBOutlet var placeDetailsView: PlaceDetailsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaceDetailsUI()

    }

    
    private func getPlaceLocation() {
        
        
    }
    
    
    
    private func setPlaceDetailsUI() {
        placeDetailsView.placeDetailsConfigure(placeDetailsName: placeDetails.name, placeDetailsAddress: placeDetails.address, placeDetailsPhoneNumber: placeDetails.internationalPhoneNumber, placeDetailsWebsite: placeDetails.website, rating: placeDetails.rating, backgroundPlaceDetailsImageURL: GooglePlacesSearchService.shared.googlePlacesPhotosURL(photoreference: place.photos[0].photoReference))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showLocationOnMapSegue,
            let mapVC = segue.destination as? MapViewController {
            mapVC.placeDetails = placeDetails
        }
    }
}
