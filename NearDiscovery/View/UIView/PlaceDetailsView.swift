//
//  PlaceDetailsView.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class PlaceDetailsView: UIView {
    
    var placeDetailsConfigureUI: PlaceDetails! {
        didSet {
            placeDetailsNameLabel.text = placeDetailsConfigureUI.name
            placeDetailsAddressLabel.text = placeDetailsConfigureUI.address
            placeDetailsWebsiteLabel.text = placeDetailsConfigureUI.website
//            ratingLabel.text = "\(String(describing: placeDetailsConfigureUI.rating))"
        }
    }

    @IBOutlet weak var placeDetailsImageView: UIImageView!
    @IBOutlet weak var placeDetailsNameLabel: UILabel!
    @IBOutlet weak var placeDetailsAddressLabel: UILabel!
    @IBOutlet weak var placeDetailsPhoneNumberLabel: UILabel!
    @IBOutlet weak var placeDetailsWebsiteLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var weekdayTextView: UITextView!
    
    
    private func convertIntoString(weekdayText: [String]) -> String {
        var schedule = ""
        for weekdayString in weekdayText {
            schedule += weekdayString + "\n"
        }
        return schedule
    }
    
    func placeDetailsConfigure(rating: Double, placeDetailsPhoneNumber: String, weekdayText: [String], backgroundPlaceDetailsImageURL: String) {
        ratingLabel.text = String(rating)
        placeDetailsPhoneNumberLabel.text = placeDetailsPhoneNumber
        weekdayTextView.text = convertIntoString(weekdayText: weekdayText)
        placeDetailsImageView.cacheImage(urlString: backgroundPlaceDetailsImageURL)
    }
}
