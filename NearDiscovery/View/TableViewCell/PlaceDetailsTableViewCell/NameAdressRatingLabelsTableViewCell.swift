//
//  NameAdressRatingLabelsTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 16/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit
import Cosmos

class NameAdressRatingLabelsTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var placeDetailsNameLabel: UILabel!
    @IBOutlet weak var placeDetailsAddressLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var openStateLabel: UILabel!
    
    //MARK: - Method
    func nameAddressRatingLabelsCellConfigure(placeDetails: PlaceDetails?) {
        placeDetailsNameLabel.text = placeDetails?.name
        
        placeDetailsAddressLabel.text = placeDetails?.address
        
        cosmosView.rating = placeDetails?.rating ?? 0.0
        cosmosView.settings.updateOnTouch = false
        
        if placeDetails?.openingHours?.openNow == true {
            openStateLabel.text = "Open"
            openStateLabel.backgroundColor = UIColor.init(red: 0/255, green: 144/255, blue: 81/255, alpha: 1)
        } else {
            openStateLabel.text = "Close"
            openStateLabel.backgroundColor = .red
        }
    }
}
