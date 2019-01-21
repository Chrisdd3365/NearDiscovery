//
//  FavoritePlaceDetailsImageTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 20/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class FavoritePlaceDetailsImageTableViewCell: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var favoritePlaceImageView: UIImageView!
    
    //MARK: - Property
    let googlePlacesSearchService = GooglePlacesSearchService()
    
    //MARK: - Method
    func placeDetailsImageCellConfigure(favoritePlace: Favorite?) {
        if let photoReferenceURL = favoritePlace?.photoReference {
            favoritePlaceImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: photoReferenceURL)))
        } else {
            favoritePlaceImageView.image = UIImage(named: "giletjaune")
        }
    }
}
