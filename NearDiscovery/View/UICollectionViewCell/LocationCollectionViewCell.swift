//
//  LocationCollectionViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 18/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlet
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var locationOpenStateLabel: UILabel!
    
    //MARK - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var locationConfigure: Location? {
        didSet {
            locationNameLabel.text = locationConfigure?.name
            locationAddressLabel.text = locationConfigure?.address
            
            if locationConfigure?.openNow == true {
                locationOpenStateLabel.text = "Open"
                locationOpenStateLabel.backgroundColor = UIColor.init(red: 0/255, green: 144/255, blue: 81/255, alpha: 1)
            } else {
                locationOpenStateLabel.text = "Close"
                locationOpenStateLabel.backgroundColor = .red
            }
            
            locationImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: locationConfigure?.photoReference ?? "")))
        }
    }
}
