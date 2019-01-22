//
//  FavoritePlaceDetailsScrollView.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 22/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit
import Cosmos

class FavoritePlaceDetailsScrollView: UIScrollView {
    //MARK: - Outlets
    @IBOutlet weak var favoritePlaceImageView: UIImageView!
    @IBOutlet weak var favoritePlaceNameLabel: UILabel!
    @IBOutlet weak var favoritePlaceAddressLabel: UILabel!
    @IBOutlet weak var favoritePlaceOpenStateLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var discoverLabel: UILabel!
    @IBOutlet weak var markedLocationButton: UIButton!
    @IBOutlet weak var scheduleTextView: UITextView!
    
    //MARK: - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    var favoritePlaceScrollViewConfigure: Favorite? {
        didSet {
            favoritePlaceNameLabel?.text = favoritePlaceScrollViewConfigure?.name
            favoritePlaceAddressLabel?.text = favoritePlaceScrollViewConfigure?.address
            
            if favoritePlaceScrollViewConfigure?.openNow == true {
                favoritePlaceOpenStateLabel.text = "Open"
                favoritePlaceOpenStateLabel.backgroundColor = UIColor.init(red: 0/255, green: 144/255, blue: 81/255, alpha: 1)
            } else {
                favoritePlaceOpenStateLabel.text = "Close"
                favoritePlaceOpenStateLabel.backgroundColor = .red
            }
            
            cosmosView.rating = favoritePlaceScrollViewConfigure?.rating ?? 0.0
            cosmosView.settings.updateOnTouch = false
            
            discoverLabel.font = UIFont(name: "EurostileBold", size: 19)
            
            scheduleTextView.text = convertDetailedFavoritePlaceSchedule(schedule: favoritePlaceScrollViewConfigure?.schedule ?? "No Schedule Available")
        }
    }
    //MARK: - Method
    func placeDetailsImageCellConfigure(place: PlaceSearch?) {
        if let photoReferenceURL = place?.photos?[0].photoReference {
            favoritePlaceImageView.sd_setImage(with: URL(string: googlePlacesSearchService.googlePlacesPhotosURL(photoreference: photoReferenceURL)))
        } else {
            favoritePlaceImageView.image = UIImage(named: "giletjaune")
        }
    }
    
    //MARK: - Helper's method
    private func convertDetailedFavoritePlaceSchedule(schedule: String) -> String {
        var description = ""
        let detailedFavoritePlaceScheduleArray = schedule.components(separatedBy: ", ")
        for weekdayText in detailedFavoritePlaceScheduleArray {
            description += weekdayText + "\n"
        }
        return description
    }
}
