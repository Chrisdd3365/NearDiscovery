//
//  PlaceDetails.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import Foundation

struct GooglePlacesDetailsResponse: Decodable {
    let result: PlaceDetails
    
    enum CodingKeys : String, CodingKey {
        case result = "result"
    }
}

struct PlaceDetails: Decodable {
    let address: String
    let geometry: Location
    let internationalPhoneNumber: String
    let name: String
    let placeId: String
    let rating: Double
    let types: [String]
    let website: String
    
    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
        case geometry = "geometry"
        case internationalPhoneNumber = "international_phone_number"
        case name = "name"
        case placeId = "place_id"
        case rating = "rating"
        case types = "types"
        case website = "website"
    }
    
    struct Location: Decodable {
        let location: LatitudeLongitude
        
        enum CodingKeys: String, CodingKey {
            case location = "location"
        }
        
        struct LatitudeLongitude: Decodable {
            let latitude: Double
            let longitude: Double
            
            enum CodingKeys: String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
}



