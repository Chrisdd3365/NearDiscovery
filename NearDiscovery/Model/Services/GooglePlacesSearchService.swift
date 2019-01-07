//
//  GooglePlacesSearchService.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import Foundation
import CoreLocation

class GooglePlacesSearchService {
    var task: URLSessionDataTask?
    
    static let shared = GooglePlacesSearchService()
    private init() {}
    
    private var googlePlacesSession = URLSession(configuration: .default)
    
    func googlePlacesSearchURL(location: CLLocation, keyword: String) -> String {
        let baseURL = Constants.GooglePlacesSearchURL.baseURL
        let locationURL = Constants.GooglePlacesSearchURL.locationURL + String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
        let rankbyURL = Constants.GooglePlacesSearchURL.rankByURL
        let keywordURL = Constants.GooglePlacesSearchURL.keywordURL + keyword
        let keyURL = Constants.GoogleApiKey.apiKeyURL + Constants.GoogleApiKey.apiKey
        
        return baseURL + locationURL + rankbyURL + keywordURL + keyURL
    }
    
    func googlePlacesPhotosURL(photoreference: String) -> String {
        let baseURL = Constants.GooglePlacesPhotosURL.baseURL
        let maxwidthURL = Constants.GooglePlacesPhotosURL.maxwidthURL
        let photoreferenceURL = Constants.GooglePlacesPhotosURL.photoreferenceURL + photoreference
        let keyURL = Constants.GoogleApiKey.apiKeyURL + Constants.GoogleApiKey.apiKey
        
        return baseURL + maxwidthURL + photoreferenceURL + keyURL
    }
    
    func getGooglePlacesSearchData(keyword: String, location: CLLocation, callback: @escaping (Bool, GooglePlacesSearchResponse) -> Void) {
        guard let url = URL(string: googlePlacesSearchURL(location: location, keyword: keyword)) else { return }
        print(url)
        task?.cancel()
        task = googlePlacesSession.dataTask(with: url) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                guard let data = data, error == nil else {
                    callback(false, GooglePlacesSearchResponse(results: []))
                    return
                }
                print(data)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, GooglePlacesSearchResponse(results: []))
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(GooglePlacesSearchResponse.self, from: data) else {
                    callback(false, GooglePlacesSearchResponse(results: []))
                    return
                }
                callback(true, responseJSON)
                print(responseJSON)
            }
        }
        task?.resume()
    }
}
