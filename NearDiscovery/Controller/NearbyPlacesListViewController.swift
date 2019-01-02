//
//  NearbyPlacesListViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 31/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit

class NearbyPlacesListViewController: UIViewController {
    var places: [Place] = []
    
    @IBOutlet weak var nearbyPlacesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nearbyPlacesTableView.reloadData()
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
        guard let cell = nearbyPlacesTableView.dequeueReusableCell(withIdentifier: "nearbyPlaceCell", for: indexPath) as? NearbyPlacesTableViewCell else {
            return UITableViewCell()
        }
        let place = places[indexPath.row]
        cell.selectionStyle = .none
        cell.nearbyPlaceCellConfigure(placeName: place.name, placeAddress: place.vicinity, rating: place.rating, placeBackgroundImageURL: "")
        return cell
    }
    

}

extension NearbyPlacesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //getDetailsForRecipe(id: matchingRecipes[indexPath.row].id)
//    }
}
