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
        setPlaceDetailsUI(placeDetails: placeDetails)

    }

    @IBAction func showWebsite(_ sender: UIButton) {
        if let placeDetails = placeDetails {
            guard let url = URL(string: placeDetails.website ?? "") else { return }
            UIApplication.shared.open(url)
        } else {
            showAlert(title: "Error", message: "Failed to get you to the website. Try again!")
        }
    }
    
    private func setPlaceDetailsUI(placeDetails: PlaceDetails) {
        placeDetailsView.placeDetailsConfigureUI = placeDetails
        placeDetailsView.placeDetailsConfigure(rating: placeDetails.rating ?? 0.0, placeDetailsPhoneNumber: placeDetails.internationalPhoneNumber ?? "no phone number available", weekdayText: (placeDetails.openingHours?.weekdayText ?? ["no schedule available"]), backgroundPlaceDetailsImageURL: GooglePlacesSearchService.shared.googlePlacesPhotosURL(photoreference: (place.photos?[0].photoReference ?? "")))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showLocationOnMapSegue,
            let mapVC = segue.destination as? MapViewController {
            mapVC.placeDetails = placeDetails
        }
    }
}
