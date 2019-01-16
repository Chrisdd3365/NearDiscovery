//
//  NameAdressRatingLabelsTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 16/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class NameAdressRatingLabelsTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var placeDetailsNameLabel: UILabel!
    @IBOutlet weak var placeDetailsAddressLabel: UILabel!
    @IBOutlet weak var placeDetailsRatingLabel: UILabel!
        
    //MARK: - Method
    func nameAddressRatingLabelsCellConfigure(placeDetails: PlaceDetails?) {
        placeDetailsNameLabel.text = placeDetails?.name
        placeDetailsAddressLabel.text = placeDetails?.address
        placeDetailsRatingLabel.text = "\(String(describing: placeDetails?.rating ?? 0.0))" + "/5"
    }
}
