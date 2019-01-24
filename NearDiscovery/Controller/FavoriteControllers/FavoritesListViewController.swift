//
//  FavoritesListViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 20/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class FavoritesListViewController: UIViewController {
    //MARK: - Outlet
    @IBOutlet weak var favoriteListTableView: UITableView!
    
    //MARK: - Property
    var favorites = Favorite.all

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItemTitle(title: "List of Favorites Places")
        favoriteListTableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTabBarControllerItemBadgeValue(index: 2)
        favorites = Favorite.all
        favoriteListTableView.reloadData()
    }

    //MARK: - Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showFavoritePlaceDetailsSegue,
            let favoritePlaceDetailsVC = segue.destination as? FavoritePlaceDetailsViewController,
            let indexPath = self.favoriteListTableView.indexPathForSelectedRow {
            let selectedFavoritePlace = favorites[indexPath.row]
            favoritePlaceDetailsVC.detailedFavoritePlace = selectedFavoritePlace
        }
    }
}

extension FavoritesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favoriteListTableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        let favorite = favorites[indexPath.row]
        
        cell.selectionStyle = .none
        cell.favoritePlaceCellConfigure = favorite
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AppDelegate.viewContext.delete(favorites[indexPath.row])
            favorites.remove(at: indexPath.row)
            CoreDataManager.saveContext()
            favoriteListTableView.beginUpdates()
            favoriteListTableView.deleteRows(at: [indexPath], with: .automatic)
            favoriteListTableView.endUpdates()
        }
    }
}

extension FavoritesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return favorites.isEmpty ? 220 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Hit the 'Favorite' Button to add a place in your favorite list!"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }
}
