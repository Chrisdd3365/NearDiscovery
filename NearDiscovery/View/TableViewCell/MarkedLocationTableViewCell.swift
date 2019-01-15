//
//  MarkedLocationTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 15/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class MarkedLocationTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var markedLocationImageView: UIImageView!
    @IBOutlet weak var markedLocationNameLabel: UILabel!
    @IBOutlet weak var markedLocationAddressLabel: UILabel!
    @IBOutlet weak var markedLocationRatingLabel: UILabel!
    @IBOutlet weak var markedLocationOpenStateLabel: UILabel!
    
    //MARK - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var location: Location? {
        didSet {
            markedLocationNameLabel.text = location?.name
            markedLocationAddressLabel.text = location?.address
            markedLocationRatingLabel.text = "\(String(describing: location?.rating ?? 0.0))"
            
            if location?.openingHours == true {
                markedLocationOpenStateLabel.text = "Open"
                markedLocationOpenStateLabel.textColor = .green
            } else {
                markedLocationOpenStateLabel.text = "Close"
                markedLocationOpenStateLabel.textColor = .red
            }
            
            markedLocationImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: location?.photoReference ?? "")))
        }
    }
}
