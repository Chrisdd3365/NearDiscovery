//
//  NearbyPlacesTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 31/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit

class NearbyPlacesTableViewCell: UITableViewCell {
    //MARK : - Outlets
    @IBOutlet weak var placeBackgroundImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    
    //MARK: - Property
    var place: PlaceSearch? {
        didSet {
            placeNameLabel.text = place?.name
            placeAddressLabel.text = place?.vicinity
            ratingLabel.text = "\(String(describing: place?.rating ?? 0.0))"
            if place?.openingHours?.openNow == true {
                openNowLabel.text = "Open"
                openNowLabel.textColor = .green
            } else {
                openNowLabel.text = "Close"
                openNowLabel.textColor = .red
            }
        }
    }
    
    func nearbyPlaceImageConfigure(placeBackgroundImageURL: String) {
        placeBackgroundImageView.cacheImage(urlString: placeBackgroundImageURL)
    }
}
