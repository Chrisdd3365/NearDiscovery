//
//  PlaceSearch.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 27/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import Foundation

struct GooglePlacesSearchResponse: Decodable {
    let results: [PlaceSearch]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct PlaceSearch: Decodable {
    let geometry: Location
    let name: String
    let openingHours: OpenNow?
    let photos: [PhotoInfo]?
    let placeId: String
    let rating: Double
    let vicinity: String
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case geometry = "geometry"
        case name = "name"
        case openingHours = "opening_hours"
        case photos = "photos"
        case vicinity = "vicinity"
        case rating = "rating"
    }
    
    struct Location: Decodable {
        let location: Coordinates
        
        enum CodingKeys: String, CodingKey {
            case location = "location"
        }
        
        struct Coordinates: Decodable {
            let latitude: Double
            let longitude: Double
            
            enum CodingKeys: String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
    
    struct OpenNow: Decodable {
        let openNow: Bool
        
        enum CodingKeys: String, CodingKey {
            case openNow = "open_now"
        }
    }
    
    struct PhotoInfo: Decodable {
        let height: Int
        let width: Int
        let photoReference: String

        enum CodingKeys: String, CodingKey {
            case height = "height"
            case width = "width"
            case photoReference = "photo_reference"
        }
    }
}

