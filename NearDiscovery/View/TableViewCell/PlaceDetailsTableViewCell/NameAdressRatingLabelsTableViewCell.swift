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
    
    //MARK: - Method
    func nameAddressRatingLabelsCellConfigure(placeDetails: PlaceDetails?) {
        placeDetailsNameLabel.text = placeDetails?.name
        placeDetailsAddressLabel.text = placeDetails?.address
        cosmosView.rating = placeDetails?.rating ?? 0.0
        cosmosView.settings.updateOnTouch = false
    }
}
