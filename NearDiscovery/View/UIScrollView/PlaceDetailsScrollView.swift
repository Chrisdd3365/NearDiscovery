//
//  PlaceDetailsScrollView.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 22/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit
import Cosmos

class PlaceDetailsScrollView: UIScrollView {
    //MARK: - Outlets
    @IBOutlet weak var placeDetailsImageView: UIImageView!
    @IBOutlet weak var placeDetailsNameLabel: UILabel!
    @IBOutlet weak var placeDetailsAddressLabel: UILabel!
    @IBOutlet weak var placeDetailsOpenStateLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var discoverLabel: UILabel!
    @IBOutlet weak var markedLocationButton: UIButton!
    @IBOutlet weak var scheduleTextView: UITextView!
    
    //MARK: - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var placeDetailsScrollViewConfigure: PlaceDetails? {
        didSet {
            placeDetailsNameLabel?.text = placeDetailsScrollViewConfigure?.name
            placeDetailsAddressLabel?.text = placeDetailsScrollViewConfigure?.address
            
            if placeDetailsScrollViewConfigure?.openingHours?.openNow == true {
                placeDetailsOpenStateLabel.text = "Open"
                placeDetailsOpenStateLabel.backgroundColor = UIColor.init(red: 0/255, green: 144/255, blue: 81/255, alpha: 1)
            } else {
                placeDetailsOpenStateLabel.text = "Close"
                placeDetailsOpenStateLabel.backgroundColor = .red
            }
            
            cosmosView.rating = placeDetailsScrollViewConfigure?.rating ?? 0.0
            cosmosView.settings.updateOnTouch = false
            
            discoverLabel.font = UIFont(name: "EurostileBold", size: 19)
            
            scheduleTextView.text = convertIntoString(weekdayText: placeDetailsScrollViewConfigure?.openingHours?.weekdayText ?? ["No Schedule Available"])
        }
    }
    //MARK: - Method
    func placeDetailsImageCellConfigure(place: PlaceSearch?) {
        if let photoReferenceURL = place?.photos?[0].photoReference {
            placeDetailsImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: photoReferenceURL)))
        } else {
            placeDetailsImageView.image = UIImage(named: "giletjaune")
        }
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
