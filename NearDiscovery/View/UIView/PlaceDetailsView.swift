//
//  PlaceDetailsView.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class PlaceDetailsView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var placeDetailsImageView: UIImageView!
    @IBOutlet weak var placeDetailsNameLabel: UILabel!
    @IBOutlet weak var placeDetailsAddressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var weekdayTextView: UITextView!
    
    //MARK: - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var placeDetailsViewConfigure: PlaceDetails? {
        didSet {
            placeDetailsNameLabel.text = placeDetailsViewConfigure?.name
            placeDetailsAddressLabel.text = placeDetailsViewConfigure?.address
            ratingLabel.text = "\(String(describing: placeDetailsViewConfigure?.rating ?? 0.0))"
            weekdayTextView.text = convertIntoString(weekdayText: placeDetailsViewConfigure?.openingHours?.weekdayText ?? [""])
        }
    }
    
    //MARK: - Method
    func placeDetailsImageConfigure(photoReference: String) {
        placeDetailsImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: photoReference)))
    }

    //MARK: - Helper's method
    private func convertIntoString(weekdayText: [String]) -> String {
        var schedule = ""
        for weekdayString in weekdayText {
            schedule += weekdayString + "\n"
        }
        return schedule
    }
}
