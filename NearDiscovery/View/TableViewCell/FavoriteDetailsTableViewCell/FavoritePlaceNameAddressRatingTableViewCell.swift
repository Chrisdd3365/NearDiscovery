//
//  FavoritePlaceNameAddressRatingTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 20/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit
import Cosmos

class FavoritePlaceNameAddressRatingTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var favoritePlaceNameLabel: UILabel!
    @IBOutlet weak var favoritePlaceAddressLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var favoritePlaceOpenStateLabel: UILabel!
    
    //MARK: - Method
    func nameAddressRatingLabelsCellConfigure(favoritePlaceDetails: Favorite?) {
        favoritePlaceNameLabel.text = favoritePlaceDetails?.name
        favoritePlaceAddressLabel.text = favoritePlaceDetails?.address
        
        if favoritePlaceDetails?.openNow == true {
            favoritePlaceOpenStateLabel.text = "Open"
            favoritePlaceOpenStateLabel.backgroundColor = UIColor.init(red: 0/255, green: 144/255, blue: 81/255, alpha: 1)
        } else {
            favoritePlaceOpenStateLabel.text = "Close"
            favoritePlaceOpenStateLabel.backgroundColor = .red
        }
        
        cosmosView.rating = favoritePlaceDetails?.rating ?? 0.0
        cosmosView.settings.updateOnTouch = false
    }
}
