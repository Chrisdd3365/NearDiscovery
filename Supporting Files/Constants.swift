//
//  Constants.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 17/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import Foundation

struct Constants {
    struct GooglePlacesURL {
        static let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        static let locationURL = "location="
        static let radiusURL = "&radius="
        static let rankByURL = "&rankby=distance"
        static let keywordURL = "&keyword="
        static let apiKeyURL = "&key="
        static let apiKey = "AIzaSyCUUCsTw3immuiortZmBUB3JEnUbtohjtQ"
    }
    
    struct SeguesIdentifiers {
        static let showNearbySegueIdentifier = "showNearbySegue"
    }
}


