//
//  LocationTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 08/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var locationOpenNowLabel: UILabel!
    @IBOutlet weak var locationRatingLabel: UILabel!
    
    //MARK - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var location: Location? {
        didSet {
            locationNameLabel.text = location?.name
            locationAddressLabel.text = location?.address
            locationRatingLabel.text = "\(String(describing: location?.rating ?? 0.0))"
            
            if location?.openingHours == true {
                locationOpenNowLabel.text = "Open"
                locationOpenNowLabel.textColor = .green
            } else {
                locationOpenNowLabel.text = "Close"
                locationOpenNowLabel.textColor = .red
            }
            
            locationImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: location?.photoReference ?? "")))
        }
    }
}
