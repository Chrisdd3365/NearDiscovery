//
//  GooglePlacesSearchServiceTests.swift
//  NearDiscoveryTests
//
//  Created by Christophe DURAND on 27/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import XCTest
import CoreLocation
@testable import NearDiscovery

class GooglePlacesSearchServiceTests: XCTestCase {
    let keyword = "museum,monument"
    let location = CLLocation(latitude: 51.50998, longitude: -0.1337)
    
    func testGetNearbyPlacesShouldGetFailedCallbackIfError() {
            // Given
            let googlePlacesSearchService = GooglePlacesSearchService(
                googlePlacesSearchSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
            // When
            let expectation = XCTestExpectation(description: "Wait for queue change.")
        googlePlacesSearchService.getGooglePlacesSearchData(keyword: keyword, location: location) { success, places  in
                // Then
                XCTAssertFalse(success)
                XCTAssertNotNil(places)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.01)
        }
    
        func testGetNearbyPlacesShouldGetFailedCallbackIfNoData() {
            // Given
            let googlePlacesSearchService = GooglePlacesSearchService(
                googlePlacesSearchSession: URLSessionFake(data: nil, response: nil, error: nil))
            // When
            let expectation = XCTestExpectation(description: "Wait for queue change.")
            googlePlacesSearchService.getGooglePlacesSearchData(keyword: keyword, location: location) { success, places in
                // Then
                XCTAssertFalse(success)
                XCTAssertNotNil(places)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.01)
        }
    
        func testGetNearbyPlacesShouldGetFailedCallbackIfIncorrectResponse() {
            // Given
            let googlePlacesSearchService = GooglePlacesSearchService(
                googlePlacesSearchSession: URLSessionFake(
                    data: FakeGooglePlacesSearchResponseData.googlePlacesSearchCorrectData,
                    response: FakeResponseData.responseKO,
                    error: nil))
    
            // When
            let expectation = XCTestExpectation(description: "Wait for queue change.")
            googlePlacesSearchService.getGooglePlacesSearchData(keyword: keyword, location: location) { success, places in
                // Then
                XCTAssertFalse(success)
                XCTAssertNotNil(places)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.01)
        }
    
        func testGetNearbyPlacesShouldGetFailedCallbackIfIncorrectData() {
            // Given
            let googlePlacesSearchService = GooglePlacesSearchService(
                googlePlacesSearchSession: URLSessionFake(
                    data: FakeResponseData.incorrectData,
                    response: FakeResponseData.responseOK,
                    error: nil))
    
            // When
            let expectation = XCTestExpectation(description: "Wait for queue change.")
            googlePlacesSearchService.getGooglePlacesSearchData(keyword: keyword, location: location) { success, places in
                // Then
                XCTAssertFalse(success)
                XCTAssertNotNil(places)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.01)
        }
    
        func testGetNearbyPlacesShouldGetSuccessCallbackIfNoErrorAndCorrectData() {
            // Given
            let googlePlacesSearchService = GooglePlacesSearchService(
                googlePlacesSearchSession: URLSessionFake(
                    data: FakeGooglePlacesSearchResponseData.googlePlacesSearchCorrectData,
                    response: FakeResponseData.responseOK,
                    error: nil))
    
            // When
            let expectation = XCTestExpectation(description: "Wait for queue change.")
            googlePlacesSearchService.getGooglePlacesSearchData(keyword: keyword, location: location) { success, places in
                // Then
                XCTAssertTrue(success)
                XCTAssertNotNil(places)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.01)
        }
    
    func testGooglePlacesPhotosURL() {
     let photoReference = "CmRaAAAARIihxHg0twaAulvvz6_-8bU7ABZGHdC5P9cuuq4QKIY_N6OlCftWCI5a_HIE75leWqvodJ8sHoG9_-B2Fx9uLyy2GbhBhYZArlsS_t9klhBHowVLdOlYRnmNwpz5_HvwEhCDg9O8xg6nbCJkqveuIZxkGhQpCnuSXZn4qLh7urdZ1QClxFXwHQ"
    let photoURLString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=CmRaAAAARIihxHg0twaAulvvz6_-8bU7ABZGHdC5P9cuuq4QKIY_N6OlCftWCI5a_HIE75leWqvodJ8sHoG9_-B2Fx9uLyy2GbhBhYZArlsS_t9klhBHowVLdOlYRnmNwpz5_HvwEhCDg9O8xg6nbCJkqveuIZxkGhQpCnuSXZn4qLh7urdZ1QClxFXwHQ&key=AIzaSyCUUCsTw3immuiortZmBUB3JEnUbtohjtQ"
        
        // Given
        let googlePlacesSearchService = GooglePlacesSearchService(
            googlePlacesSearchSession: URLSessionFake(
                data: FakeGooglePlacesSearchResponseData.googlePlacesSearchCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
            // When
        let photoURL = googlePlacesSearchService.googlePlacesPhotosURL(photoreference: photoReference)
        // Then
        XCTAssertEqual(photoURL, photoURLString)
    }
}
