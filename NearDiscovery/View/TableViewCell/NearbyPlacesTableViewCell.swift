//
//  NearbyPlacesTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 31/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit

class NearbyPlacesTableViewCell: UITableViewCell {
    @IBOutlet weak var placeBackgroundImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    func nearbyPlaceCellConfigure(placeName: String, placeAddress: String, rating: Double, placeBackgroundImageURL: String) {
        placeNameLabel.text = placeName
        placeAddressLabel.text = placeAddress
        ratingLabel.text = String(rating)
        //placeBackgroundImageView.load(imageURL: backgroundRecipeImageURL)
    }
}
