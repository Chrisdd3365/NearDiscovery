//
//  PlaceDetailsServices.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 18/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class PlaceDetailsServices {
    var task: URLSessionDataTask?
    private var placeDetailsSession: URLSession
    
    init(placeDetailsSession: URLSession = URLSession(configuration: .default)) {
        self.placeDetailsSession = placeDetailsSession
    }
    
    func nearPlacesCoordinatesUrl(coordinate: CLLocationCoordinate2D, types: [String]) -> String {
        let baseURL = Constants.GooglePlacesURL.baseURL
        let locationString = Constants.GooglePlacesURL.locationURL + String(coordinate.latitude) + "," + String(coordinate.longitude)
        let rankby = Constants.GooglePlacesURL.rankByURL
        let sensor = Constants.GooglePlacesURL.sensorURL
        let key = Constants.GooglePlacesURL.apiKeyURL + Constants.GooglePlacesURL.apiKey
        let typesURL = Constants.GooglePlacesURL.typesURL
        let typesString = types.count > 0 ? types.joined(separator: "|") : "food"
        var urlString = baseURL + locationString + rankby + sensor + key
        urlString += typesURL + "\(typesString)"
        guard let urlStringConverted = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return ""}
        
        return urlStringConverted
    }
    
    func getNearPlacesCoordinates(_ coordinate: CLLocationCoordinate2D, radius: Double, types:[String], callback: @escaping (PlaceDetails?) -> Void) {
        guard let url = URL(string: nearPlacesCoordinatesUrl(coordinate: coordinate, types: types)) else { return }
        task?.cancel()
        task = placeDetailsSession.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(nil)
                    return
                }
                guard let placeDetailsResponseJSON = try? JSONDecoder().decode(PlaceDetails.self, from: data) else {
                    callback(nil)
                    return
                }
                callback(placeDetailsResponseJSON)
                print(placeDetailsResponseJSON)
            }
        }
        task?.resume()
    }
}
