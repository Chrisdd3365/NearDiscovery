//
//  Place.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 27/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import Foundation

struct GooglePlacesResponse: Codable {
    let results : [Place]
    enum CodingKeys : String, CodingKey {
        case results = "results"
    }
}

struct Place: Codable {
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
    
    struct Location: Codable {
        let location : LatitudeLongitude
        
        enum CodingKeys: String, CodingKey {
            case location = "location"
        }
        
        struct LatitudeLongitude: Codable {
            let latitude: Double
            let longitude: Double
            
            enum CodingKeys: String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
    
    struct OpenNow: Codable {
        let isOpen: Bool
        
        enum CodingKeys: String, CodingKey {
            case isOpen = "open_now"
        }
    }
    
    struct PhotoInfo: Codable {
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
