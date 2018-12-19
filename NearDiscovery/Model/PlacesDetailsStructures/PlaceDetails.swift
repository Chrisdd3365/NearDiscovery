//
//  PlaceDetails.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 18/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import Foundation

struct GooglePlacesResponse: Decodable {
    let results : [PlaceDetails]
    enum CodingKeys : String, CodingKey {
        case results = "results"
    }
}

struct PlaceDetails: Decodable {
    let placeId: String
    let geometry: Location
    let name: String
    let openingHours: OpenNow?
    let photos: [PhotoInfo]
    let types: [String]
    let address: String
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case geometry = "geometry"
        case name = "name"
        case openingHours = "opening_hours"
        case photos = "photos"
        case types = "types"
        case address = "vicinity"
        case rating = "rating"
    }
    
    struct Location: Decodable {
        let location : LatLong
        
        enum CodingKeys: String, CodingKey {
            case location = "location"
        }
        
        struct LatLong: Decodable {
            let latitude: Double
            let longitude: Double
            
            enum CodingKeys: String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
    
    struct OpenNow: Decodable {
        let isOpen: Bool
        
        enum CodingKeys: String, CodingKey {
            case isOpen = "open_now"
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

