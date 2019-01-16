//
//  ImageTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 16/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var placeDetailsImageView: UIImageView!
    
    //MARK: - Property
    let googlePlacesSearchService = GooglePlacesSearchService()

    //MARK: - Method
    func placeDetailsImageCellConfigure(place: PlaceSearch?) {
        if let photoReferenceURL = place?.photos?[0].photoReference {
            placeDetailsImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: photoReferenceURL)))
        } else {
            placeDetailsImageView.image = UIImage(named: "giletjaune")
        }
    }
}
