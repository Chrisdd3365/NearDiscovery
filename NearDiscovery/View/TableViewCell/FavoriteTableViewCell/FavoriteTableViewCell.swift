//
//  FavoriteTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 20/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit
import Cosmos

class FavoriteTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var favoritePlaceName: UILabel!
    @IBOutlet weak var favoritePlaceAddress: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var favoritePlaceImageView: UIImageView!
    @IBOutlet weak var favoritePlaceOpenState: UILabel!
    
    //MARK: - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var favoritePlaceCellConfigure: Favorite? {
        didSet {
            favoritePlaceName.text = favoritePlaceCellConfigure?.name
            favoritePlaceName.font = UIFont(name: "EurostileBold", size: 18)
            
            favoritePlaceAddress.text = favoritePlaceCellConfigure?.address
            
            cosmosView.rating = favoritePlaceCellConfigure?.rating ?? 0.0
            cosmosView.settings.updateOnTouch = false
            
            if favoritePlaceCellConfigure?.openNow == true {
                favoritePlaceOpenState.text = "Open"
                favoritePlaceOpenState.backgroundColor = UIColor.init(red: 0/255, green: 144/255, blue: 81/255, alpha: 1)
            } else {
                favoritePlaceOpenState.text = "Close"
                favoritePlaceOpenState.backgroundColor = .red
            }
            
            if let photoReferenceURL = favoritePlaceCellConfigure?.photoReference {
                favoritePlaceImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: photoReferenceURL)))
            } else {
                favoritePlaceImageView.image = UIImage(named: "giletjaune")
            }
        }
    }
}
