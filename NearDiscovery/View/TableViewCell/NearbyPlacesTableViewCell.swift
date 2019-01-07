//
//  NearbyPlacesTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 31/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit

class NearbyPlacesTableViewCell: UITableViewCell {
    
    var place: PlaceSearch! {
        didSet {
            placeNameLabel.text = place.name
            placeAddressLabel.text = place.vicinity
            ratingLabel.text = "\(String(describing: place.rating))"
        }
    }
    
    @IBOutlet weak var placeBackgroundImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    

    func nearbyPlaceImageConfigure(placeBackgroundImageURL: String) {
        placeBackgroundImageView.cacheImage(urlString: placeBackgroundImageURL)
    }
}
