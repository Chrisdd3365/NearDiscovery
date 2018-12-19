//
//  PlaceMarker.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 19/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class PlaceMarker: NSObject {
    let place: PlaceDetails
    var location: CLLocation
    var name: String
    var address: String
    var imageName: String
    
    init(place: PlaceDetails) {
        self.place = place
        self.location = CLLocation(latitude: place.geometry.location.latitude, longitude: place.geometry.location.longitude)
        self.name = place.name
        self.address = place.address
        self.imageName = place.photos[0].photoReference
    }
}

extension PlaceMarker: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
    }
    
    var title: String? {
        get {
            return name
        }
    }
    var subtitle: String? {
        get {
            return address
        }
    }
}
