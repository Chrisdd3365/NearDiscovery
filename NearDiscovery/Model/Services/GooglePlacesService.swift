//
//  GooglePlacesService.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 27/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import Foundation
import CoreLocation

class GooglePlacesService {
    var task: URLSessionDataTask?
    
    static let shared = GooglePlacesService()
    private init() {}
    
    private var googlePlacesSession = URLSession(configuration: .default)
    
    func googlePlacesURL(location: CLLocation, keyword: String) -> String {
        let baseURL = Constants.GooglePlacesURL.baseURL
        let locationURL = Constants.GooglePlacesURL.locationURL + String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
        let rankbyURL = Constants.GooglePlacesURL.rankByURL
        let keywordURL = Constants.GooglePlacesURL.keywordURL + keyword
        let keyURL = Constants.GooglePlacesURL.apiKeyURL + Constants.GooglePlacesURL.apiKey
    
        return baseURL + locationURL + rankbyURL + keywordURL + keyURL
    }
    
    func getGooglePlacesData(keyword: String, location: CLLocation, callback: @escaping (Bool, GooglePlacesResponse) -> Void) {
        guard let url = URL(string: googlePlacesURL(location: location, keyword: keyword)) else { return }
        print(url)
        task?.cancel()
        task = googlePlacesSession.dataTask(with: url) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                guard let data = data, error == nil else {
                    callback(false, GooglePlacesResponse(results: []))
                    return
                }
                print(data)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, GooglePlacesResponse(results: []))
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) else {
                    callback(false, GooglePlacesResponse(results: []))
                    return
                }
                callback(true, responseJSON)
                print(responseJSON)
            }
        }
        task?.resume()
    }
}
