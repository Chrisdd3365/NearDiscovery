//
//  PlaceDetailsServicesTests.swift
//  NearDiscoveryTests
//
//  Created by Christophe DURAND on 19/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import XCTest
import CoreLocation
@testable import NearDiscovery

class PlaceDetailsServicesTests: XCTestCase {
    let types = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    let location = CLLocationCoordinate2D(latitude: 48.866667, longitude: 2.333333)
    let radius = 1000.0

    func testGetNearPlacesCoordinatesShouldGetFailedCallbackIfError() {
        // Given
        let placeDetailsServices = PlaceDetailsServices(
            placeDetailsSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeDetailsServices.getNearPlacesCoordinates(location, radius: 1000.0, types: .bakery ) { places in
            // Then
            XCTAssertNil(places)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetNearPlacesCoordinatesShouldGetFailedCallbackIfNoData() {
        // Given
        let placeDetailsServices = PlaceDetailsServices(
            placeDetailsSession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeDetailsServices.getNearPlacesCoordinates(location, radius: radius, types: .bakery) { places in
            // Then
            XCTAssertNil(places)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetNearPlacesCoordinatesShouldGetFailedCallbackIfIncorrectResponse() {
        // Given
        let placeDetailsServices = PlaceDetailsServices(
            placeDetailsSession: URLSessionFake(
                data: FakePlaceDetailsResponseData.placeDetailsCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeDetailsServices.getNearPlacesCoordinates(location, radius: radius, types: .bakery) { places in
            // Then
            XCTAssertNil(places)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetNearPlacesCoordinatesShouldGetFailedCallbackIfIncorrectData() {
        // Given
        let placeDetailsServices = PlaceDetailsServices(
            placeDetailsSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeDetailsServices.getNearPlacesCoordinates(location, radius: radius, types: .bakery) { places in
            // Then
            XCTAssertNil(places)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetNearPlacesCoordinatesShouldGetSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let placeDetailsServices = PlaceDetailsServices(
            placeDetailsSession: URLSessionFake(
                data: FakePlaceDetailsResponseData.placeDetailsCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        placeDetailsServices.getNearPlacesCoordinates(location, radius: radius, types: .bakery) { places in
            // Then
            XCTAssertNil(places)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
