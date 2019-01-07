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
    let internationalPhoneNumber: String?
    let name: String
    let openingHours: OpenNow?
    let placeId: String
    let rating: Double?
    let website: String?
    
    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
        case geometry = "geometry"
        case internationalPhoneNumber = "international_phone_number"
        case name = "name"
        case openingHours = "opening_hours"
        case placeId = "place_id"
        case rating = "rating"
        case website = "website"
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
        let weekdayText: [String]
        
        enum CodingKeys: String, CodingKey {
            case openNow = "open_now"
            case weekdayText = "weekday_text"
        }
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        self.address = try container.decode(String.self, forKey: .address)
//        self.geometry = try container.decode(Location.self, forKey: .geometry)
//        self.internationalPhoneNumber = try? container.decode(String.self, forKey: .internationalPhoneNumber)
//        self.name = try container.decode(String.self, forKey: .openingHours)
//        self.openingHours = try? container.decode(OpenNow.self, forKey: .openingHours)
//        self.placeId = try container.decode(String.self, forKey: .placeId)
//        self.rating = try container.decode(Double.self, forKey: .rating)
//        self.website = try? container.decode(String.self, forKey: .website)
//    }
}

