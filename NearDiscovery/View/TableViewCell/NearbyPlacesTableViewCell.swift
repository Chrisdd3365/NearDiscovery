//
//  NearbyPlacesTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 31/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit
import SDWebImage


class NearbyPlacesTableViewCell: UITableViewCell {
    //MARK : - Outlets
    @IBOutlet weak var placeBackgroundImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    
    //MARK: - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var nearbyPlaceCellConfigure: PlaceSearch? {
        didSet {
            placeNameLabel.text = nearbyPlaceCellConfigure?.name
            placeAddressLabel.text = nearbyPlaceCellConfigure?.vicinity
            ratingLabel.text = "\(String(describing: nearbyPlaceCellConfigure?.rating ?? 0.0))"
            
            if nearbyPlaceCellConfigure?.openingHours?.openNow == true {
                openNowLabel.text = "Open"
                openNowLabel.textColor = .green
            } else {
                openNowLabel.text = "Close"
                openNowLabel.textColor = .red
            }
            
            placeBackgroundImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: nearbyPlaceCellConfigure?.photos?[0].photoReference ?? "")))
        }
    }
}
