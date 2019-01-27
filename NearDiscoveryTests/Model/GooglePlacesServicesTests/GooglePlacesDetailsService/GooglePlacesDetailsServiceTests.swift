//
//  GooglePlacesDetailsServiceTests.swift
//  NearDiscoveryTests
//
//  Created by Christophe DURAND on 27/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import XCTest
import CoreLocation
@testable import NearDiscovery

class GooglePlacesDetailsServiceTests: XCTestCase {
    let placeId = "ChIJnb7y0dMEdkgRioHu_Uv61D0"
    
    func testGetPlaceDetailsShouldGetFailedCallbackIfError() {
        // Given
        let googlePlacesDetailsService = GooglePlacesDetailsService(
            googlePlacesDetailsSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        googlePlacesDetailsService.getGooglePlacesDetailsData(placeId: placeId) { success, placeDetails  in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(placeDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlaceDetailsShouldGetFailedCallbackIfNoData() {
        // Given
        let googlePlacesDetailsService = GooglePlacesDetailsService(
            googlePlacesDetailsSession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        googlePlacesDetailsService.getGooglePlacesDetailsData(placeId: placeId) { success, placeDetails in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(placeDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlaceDetailsShouldGetFailedCallbackIfIncorrectResponse() {
        // Given
        let googlePlacesDetailsService = GooglePlacesDetailsService(
            googlePlacesDetailsSession: URLSessionFake(
                data: FakeGooglePlacesSearchResponseData.googlePlacesSearchCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        googlePlacesDetailsService.getGooglePlacesDetailsData(placeId: placeId) { success, placeDetails in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(placeDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlaceDetailsShouldGetFailedCallbackIfIncorrectData() {
        // Given
        let googlePlacesDetailsService = GooglePlacesDetailsService(
            googlePlacesDetailsSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        googlePlacesDetailsService.getGooglePlacesDetailsData(placeId: placeId) { success, placeDetails in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(placeDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetPlaceDetailsShouldGetSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let googlePlacesDetailsService = GooglePlacesDetailsService(
            googlePlacesDetailsSession: URLSessionFake(
                data: FakeGooglePlacesDetailsResponseData.googlePlacesDetailsCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        googlePlacesDetailsService.getGooglePlacesDetailsData(placeId: placeId) { success, placeDetails in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(placeDetails)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
