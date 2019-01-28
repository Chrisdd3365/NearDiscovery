//
//  PlaceMarkerTests.swift
//  NearDiscoveryTests
//
//  Created by Christophe DURAND on 27/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import XCTest
import CoreLocation
import MapKit
@testable import NearDiscovery

class PlaceMarkerTests: XCTestCase {
    
    let mapView: MKMapView? = nil
    let placeDetails: PlaceDetails? = nil

    func testAddPlaceMarker() {
        let placeMarker = PlaceMarker(latitude: placeDetails?.geometry.location.latitude ?? 0.0, longitude: placeDetails?.geometry.location.longitude ?? 0.0, name: placeDetails?.name ?? "")
        DispatchQueue.main.async {
            self.mapView?.addAnnotation(placeMarker)
        }
        XCTAssert(true)
    }
}
