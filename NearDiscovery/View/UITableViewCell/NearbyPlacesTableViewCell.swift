//
//  NearbyPlacesTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 31/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class NearbyPlacesTableViewCell: UITableViewCell {
    //MARK : - Outlets
    @IBOutlet weak var placeBackgroundImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    //MARK: - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var nearbyPlaceCellConfigure: PlaceSearch? {
        didSet {
            placeNameLabel.text = nearbyPlaceCellConfigure?.name
            placeNameLabel.font = UIFont(name: "EurostileBold", size: 18)
            
            placeAddressLabel.text = nearbyPlaceCellConfigure?.vicinity
            
            cosmosView.rating = nearbyPlaceCellConfigure?.rating ?? 0.0
            cosmosView.settings.updateOnTouch = false
            
            if nearbyPlaceCellConfigure?.openingHours?.openNow == true {
                openNowLabel.text = "Open".localized()
                openNowLabel.backgroundColor = UIColor.init(red: 0/255, green: 144/255, blue: 81/255, alpha: 1)
            } else {
                openNowLabel.text = "Close".localized()
                openNowLabel.backgroundColor = .red
            }
            
            if let photoReferenceURL = nearbyPlaceCellConfigure?.photos?[0].photoReference {
                placeBackgroundImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: photoReferenceURL)))
            } else {
                placeBackgroundImageView.image = UIImage(named: "defaultImage")
            }
        }
    }
}
