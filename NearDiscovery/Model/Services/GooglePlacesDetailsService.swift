//
//  GooglePlacesDetailsService.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import Foundation

class GooglePlacesDetailsService {
    //MARK: - Properties
    var task: URLSessionDataTask?
    private var googlePlacesDetailsSession: URLSession
    
    //MARK: - Initializers
    init(googlePlacesDetailsSession: URLSession = URLSession(configuration: .default)) {
        self.googlePlacesDetailsSession = googlePlacesDetailsSession
    }
    
    //MARK: - Methods
    //Helper's methods URL
    func googlePlacesDetailsURL(placeId: String) -> String {
        let baseURL = Constants.GooglePlacesDetailsURL.baseURL
        let placeIdURL = Constants.GooglePlacesDetailsURL.placeIdURL + placeId
        let keyURL = Constants.GoogleApiKey.apiKeyURL + Constants.GoogleApiKey.apiKey
        
        return baseURL + placeIdURL + keyURL
    }
    
    //API method
    func getGooglePlacesDetailsData(placeId: String, callback: @escaping (Bool, GooglePlacesDetailsResponse?) -> Void) {
        guard let url = URL(string: googlePlacesDetailsURL(placeId: placeId)) else { return }
        task?.cancel()
        task = googlePlacesDetailsSession.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(GooglePlacesDetailsResponse.self, from: data) else {
                    callback(false, nil)
                    return
                }
                callback(true, responseJSON)
            }
        }
        task?.resume()
    } 
}
