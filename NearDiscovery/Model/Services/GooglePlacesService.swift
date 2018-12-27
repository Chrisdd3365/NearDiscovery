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
    private var googlePlacesSession: URLSession
    
    init(googlePlacesSession: URLSession = URLSession(configuration: .default)) {
        self.googlePlacesSession = googlePlacesSession
    }
    
    func googlePlacesURL(location: CLLocation, keyword: String) -> String {

        let baseURL = Constants.GooglePlacesURL.baseURL
        let locationURL = Constants.GooglePlacesURL.locationURL + String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
        let rankbyURL = Constants.GooglePlacesURL.rankByURL
        let keywordURL = Constants.GooglePlacesURL.keywordURL + keyword
        let keyURL = Constants.GooglePlacesURL.apiKeyURL + Constants.GooglePlacesURL.apiKey

        return baseURL + locationURL + rankbyURL + keywordURL + keyURL
    }
    
    func getGooglePlacesData(forKeyword keyword: String, location: CLLocation, withinMeters radius: Int, using callback: @escaping (GooglePlacesResponse) -> Void)  {
        guard let url = URL(string: googlePlacesURL(location: location, keyword: keyword)) else { return }
        task?.cancel()
        task = googlePlacesSession.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                callback(GooglePlacesResponse(results: []))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(GooglePlacesResponse(results: []))
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) else {
                callback(GooglePlacesResponse(results: []))
                return
            }
            callback(responseJSON)
            print(responseJSON)
        }
        task?.resume()
    }
 
    
    
    
    
    
    
//    func getNearPlacesCoordinates(_ location: CLLocationCoordinate2D, radius: Double, types: String, callback: @escaping (Place?) -> Void) {
//        guard let url = URL(string: nearPlacesCoordinatesUrl(location: location, radius: radius, types: types)) else { return }
//        task?.cancel()
//        task = googlePlacesSession.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                guard let data = data, error == nil else {
//                    callback(nil)
//                    return
//                }
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                    callback(nil)
//                    return
//                }
//                guard let googlePlacesResponseJSON = try? JSONDecoder().decode(Place.self, from: data) else {
//                    callback(nil)
//                    return
//                }
//                callback(googlePlacesResponseJSON)
//            }
//        }
//        task?.resume()
//    }
}
