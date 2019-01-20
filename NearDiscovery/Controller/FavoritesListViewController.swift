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
    
    
//    //MARK: - Properties
//    var favoritesRecipes = FavoriteRecipe.all
//
//    //MARK: - View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setNavigationBarTitle()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        setTabBarControllerItemBadgeValue()
//        favoritesRecipes = FavoriteRecipe.all
//        favoritesRecipesListTableView.reloadData()
//    }
//
//    //MARK: - Methods
//    //Method to setup the navigation bar's title
//    private func setNavigationBarTitle() {
//        self.navigationItem.title = "List of Favorites Recipes"
//    }
//    //Method to setup the tab bar controller item badge's value
//    private func setTabBarControllerItemBadgeValue() {
//        guard let tabItems = tabBarController?.tabBar.items else { return }
//        let tabItem = tabItems[1]
//        tabItem.badgeValue = nil
//    }
//    //Method to save context
//    private func saveContext() {
//        do {
//            try AppDelegate.viewContext.save()
//        } catch let error as NSError {
//            print(error)
//        }
//    }
//    //Method to pass datas from FavoritesRecipesListViewController to DetailedFavoriteRecipeViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SeguesIdentifiers.detailedFavoriteRecipeSegueIdentifier,
//            let detailedFavoriteRecipeVC = segue.destination as? DetailedFavoriteRecipeViewController,
//            let indexPath = self.favoritesRecipesListTableView.indexPathForSelectedRow {
//            let selectedFavoriteRecipe = favoritesRecipes[indexPath.row]
//            detailedFavoriteRecipeVC.detailedFavoriteRecipe = selectedFavoriteRecipe
//        }
//    }

}

//extension FavoritesRecipesListViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return favoritesRecipes.count
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = "Hit the favorite button to add a recipe in your favorite list!"
//        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.textColor = .gray
//        return label
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return favoritesRecipes.isEmpty ? 200 : 0
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = favoritesRecipesListTableView.dequeueReusableCell(withIdentifier: CellsIdentifiers.favoriteRecipeCellIdentifier, for: indexPath) as? FavoriteRecipeTableViewCell else {
//            return UITableViewCell()
//        }
//        let favoriteRecipe = favoritesRecipes[indexPath.row]
//        cell.selectionStyle = .none
//        cell.favoriteRecipeCellConfigure(favoriteRecipeName: favoriteRecipe.recipeName!, favoriteRecipeDetails: favoriteRecipe.ingredients!, ratings: Int(favoriteRecipe.rating), timer: Int(favoriteRecipe.totalTimeInSeconds) / 60, backgroundRecipeImageURL: favoriteRecipe.image!)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            AppDelegate.viewContext.delete(favoritesRecipes[indexPath.row])
//            favoritesRecipes.remove(at: indexPath.row)
//            saveContext()
//            favoritesRecipesListTableView.beginUpdates()
//            favoritesRecipesListTableView.deleteRows(at: [indexPath], with: .automatic)
//            favoritesRecipesListTableView.endUpdates()
//        }
//    }
//}
