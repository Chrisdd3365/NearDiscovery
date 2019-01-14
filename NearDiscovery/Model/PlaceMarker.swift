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
    //MARK: - Properties
    var location: CLLocation
    var name: String

    init(latitude: Double, longitude: Double, name: String) {
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.name = name
    }
}

//MARK: MKAnnotation
extension PlaceMarker: MKAnnotation {
    //MARK: - Properties
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
}
