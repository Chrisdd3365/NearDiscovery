//
//  PlaceDetailsView.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class PlaceDetailsView: UIView {

    @IBOutlet weak var placeDetailsImageView: UIImageView!
    @IBOutlet weak var placeDetailsNameLabel: UILabel!
    @IBOutlet weak var placeDetailsAddressLabel: UILabel!
    @IBOutlet weak var placeDetailsPhoneNumberLabel: UILabel!
    @IBOutlet weak var placeDetailsWebsiteLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    func placeDetailsConfigure(placeDetailsName: String, placeDetailsAddress: String, placeDetailsPhoneNumber: String, placeDetailsWebsite: String, rating: Double, backgroundPlaceDetailsImageURL: String) {
        placeDetailsNameLabel.text = placeDetailsName
        placeDetailsAddressLabel.text = placeDetailsAddress
        placeDetailsPhoneNumberLabel.text = placeDetailsPhoneNumber
        placeDetailsWebsiteLabel.text = placeDetailsWebsite
        ratingLabel.text = String(rating)
        placeDetailsImageView.cacheImage(urlString: backgroundPlaceDetailsImageURL)
    }
}
