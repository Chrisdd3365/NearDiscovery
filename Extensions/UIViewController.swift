//
//  UIViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 18/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func setNavigationItemTitle(title: String) {
        navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "EurostileBold", size: 20) ?? UIFont(name: "", size: 0) as Any]
    }
    
    func setTabBarControllerItemBadgeValue(index: Int) {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        let tabItem = tabItems[index]
        tabItem.badgeValue = nil
    }
}
