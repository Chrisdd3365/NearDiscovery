//
//  NearbyPlacesListViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 31/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit

class NearbyPlacesListViewController: UIViewController {
    var places: [PlaceSearch] = []
    var placeDetails: PlaceDetails!
    
    
    @IBOutlet weak var nearbyPlacesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyPlacesTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nearbyPlacesTableView.reloadData()
    }
    
    private func getPlaceDetails(placeId: String) {
        GooglePlacesDetailsService.shared.getGooglePlacesDetailsData(placeId: placeId) { (success, placeDetails)  in
            if success, let placeDetails = placeDetails {
                self.placeDetails = placeDetails.result
                self.performSegue(withIdentifier: Constants.SeguesIdentifiers.showDetailsSegue, sender: self)
            } else {
                self.showAlert(title: "Error", message: "Google places API datas download failed!")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showDetailsSegue,
            let placeDetailsVC = segue.destination as? PlaceDetailsViewController,
            let indexPath = self.nearbyPlacesTableView.indexPathForSelectedRow {
            let selectedPlace = places[indexPath.row]
            placeDetailsVC.placeDetails = placeDetails
            placeDetailsVC.place = selectedPlace
        }
    }
}

extension NearbyPlacesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = nearbyPlacesTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.nearbyPlaceCell, for: indexPath) as? NearbyPlacesTableViewCell else {
            return UITableViewCell()
        }
        
        let place = places[indexPath.row]
        
        cell.selectionStyle = .none
        cell.nearbyPlaceCellConfigure(placeName: place.name, placeAddress: place.vicinity, rating: place.rating, placeBackgroundImageURL: GooglePlacesSearchService.shared.googlePlacesPhotosURL(photoreference: place.photos[0].photoReference))
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 3
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 0.0
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
    
        return cell
    }
}

extension NearbyPlacesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getPlaceDetails(placeId: places[indexPath.row].placeId)
    }
}

