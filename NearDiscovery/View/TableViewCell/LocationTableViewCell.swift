//
//  LocationTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 08/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var locationOpenNowLabel: UILabel!
    @IBOutlet weak var locationRatingLabel: UILabel!
    
//    var location: Location! {
//        didSet {
//            locationNameLabel.text = place.name
//            locationAddressLabel.text = place.vicinity
//            ratingLabel.text = "\(String(describing: place.rating))"
//            if place.openingHours?.openNow == true {
//                openNowLabel.text = "Open"
//                openNowLabel.textColor = .green
//            } else {
//                openNowLabel.text = "Close"
//                openNowLabel.textColor = .red
//            }
//        }
//    }
    
    
    
    func locationCellConfigure(locationName: String, locationAddress: String, rating: Double, imageURL: String) {
        locationNameLabel.text = locationName
        locationAddressLabel.text = locationAddress
        locationRatingLabel.text = String(rating)
        locationImageView.cacheImage(urlString: imageURL)
    }
}
