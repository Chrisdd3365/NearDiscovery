//
//  TypesViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 18/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit

protocol TypesViewControllerDelegate: class {
    func typesController(_ controller: TypesViewController, didSelectTypes types: [String])
}

class TypesViewController: UIViewController {
    
    private let possibleTypesDictionary = ["bakery": "Bakery", "bar": "Bar", "cafe": "Cafe", "grocery_or_supermarket": "Supermarket", "restaurant": "Restaurant"]
    private var sortedKeys: [String] {
        return possibleTypesDictionary.keys.sorted()
    }
    var selectedTypes: [String] = []
    weak var delegate: TypesViewControllerDelegate?

}
extension TypesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleTypesDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)
        let key = sortedKeys[indexPath.row]
        let type = possibleTypesDictionary[key]
        cell.textLabel?.text = type
        cell.imageView?.image = UIImage(named: key)
        cell.accessoryType = selectedTypes.contains(key) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = sortedKeys[indexPath.row]
        if selectedTypes.contains(key) {
            selectedTypes = selectedTypes.filter({$0 != key})
        } else {
            selectedTypes.append(key)
        }
        tableView.reloadData()
    }
}
