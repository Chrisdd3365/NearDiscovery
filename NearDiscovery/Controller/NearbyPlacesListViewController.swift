//
//  NearbyPlacesListViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 31/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit

class NearbyPlacesListViewController: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var nearbyPlacesTableView: UITableView!
    
    //MARK: - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    let googlePlacesDetailsService = GooglePlacesDetailsService()
    var places: [PlaceSearch] = []
    var placeDetails: PlaceDetails!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItemTitle()
        nearbyPlacesTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nearbyPlacesTableView.reloadData()
    }
    
    //MARK: - Methods
    private func setNavigationItemTitle() {
        navigationItem.title = "Nearby Places To Visit"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "EurostileBold", size: 20)!]
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

//MARK: - API Fetch Google Places Details Data method
extension NearbyPlacesListViewController {
    private func getPlaceDetails(placeId: String) {
        googlePlacesDetailsService.getGooglePlacesDetailsData(placeId: placeId) { (success, placeDetails)  in
            if success, let placeDetails = placeDetails {
                self.placeDetails = placeDetails.result
                self.performSegue(withIdentifier: Constants.SeguesIdentifiers.showDetailsSegue, sender: self)
            } else {
                self.showAlert(title: "Error", message: "Google places API datas download failed!")
            }
        }
    }
}

//MARK: - TableViewDataSource's methods
extension NearbyPlacesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = nearbyPlacesTableView.dequeueReusableCell(withIdentifier: NearbyPlacesTableViewCell.identifier, for: indexPath) as? NearbyPlacesTableViewCell else {
            return UITableViewCell()
        }
        
        let place = places[indexPath.row]
        
        cell.selectionStyle = .none
        cell.nearbyPlaceCellConfigure = place
        
        return cell
    }
}

//MARK: - TableViewDelegate's methods
extension NearbyPlacesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getPlaceDetails(placeId: places[indexPath.row].placeId)
    }
}

