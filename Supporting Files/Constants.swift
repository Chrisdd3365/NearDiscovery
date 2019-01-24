//
//  Constants.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 17/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import Foundation

struct Constants {
    struct GoogleApiKey {
        static let apiKeyURL = "&key="
        static let apiKey = "AIzaSyCUUCsTw3immuiortZmBUB3JEnUbtohjtQ"
    }
    
    struct GooglePlacesSearchURL {
        static let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        static let locationURL = "location="
        static let radiusURL = "&radius="
        static let rankByURL = "&rankby=distance"
        static let keywordURL = "&keyword="
    }
    
    struct GooglePlacesPhotosURL {
        static let baseURL = "https://maps.googleapis.com/maps/api/place/photo?"
        static let maxwidthURL = "maxwidth=400"
        static let photoreferenceURL = "&photoreference="
    }
    
    struct GooglePlacesDetailsURL {
        static let baseURL = "https://maps.googleapis.com/maps/api/place/details/json?"
        static let placeIdURL = "placeid="
    }
    
    struct SeguesIdentifiers {
        static let showNearbySegue = "showNearbySegue"
        static let showDetailsSegue = "showDetailsSegue"
        static let showLocationOnMapSegue = "showLocationOnMapSegue"
        static let showFavoritePlaceDetailsSegue = "showFavoritePlaceDetailsSegue"
        static let showFavoriteLocationOnMapSegue = "showFavoriteLocationOnMapSegue"
    }
    
    struct AnnotationsIdentifiers {
        static let placeMarkerIdentifier = "PlaceMarker"
    }
}


