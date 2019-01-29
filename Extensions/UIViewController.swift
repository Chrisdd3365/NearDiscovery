//
//  UIViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 18/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit

extension UIViewController {
    func checkFavoritePlace(favorites: [Favorite], placeDetailsPlaceId: String) -> Bool {
        var isAdded = false
        guard favorites.count != 0 else { return false }
        for favorite in favorites {
            if placeDetailsPlaceId == favorite.placeId {
                isAdded = true
                break
            }
        }
        return isAdded
    }
    
    func checkMarkedLocation(locations: [Location], placeDetailsPlaceId: String) -> Bool {
        var isAdded = false
        guard locations.count != 0 else { return false }
        for location in locations {
            if placeDetailsPlaceId == location.placeId {
                isAdded = true
                break
            }
        }
        return isAdded
    }
    
    //Update the favorite button image or marked location button image
    func updateButtonImage(check: Bool, checkedImage: String, uncheckedImage: String) -> UIImage {
        var image: UIImage!
        if check {
            image = UIImage(named: checkedImage)
        } else {
            image = UIImage(named: uncheckedImage)
        }
        return image
    }
    
    //Helper's method for call
    func cleanPhoneNumberConverted(phoneNumber: String?) -> String {
        let phoneNumber = String(describing: phoneNumber ?? "0000000000")
        let phoneNumberConverted = phoneNumber.replacingOccurrences(of: " ", with: "")
        return phoneNumberConverted
    }
    
    //Call
    func didTapCallButton(phoneNumber: String) {
        let phoneNumber = cleanPhoneNumberConverted(phoneNumber: phoneNumber)
        let phoneURL = URL(string: ("tel://\(phoneNumber)"))
        if let phoneURL = phoneURL {
            UIApplication.shared.open(phoneURL)
        }
    }
    
    //Share
    func didTapShareButton(url: String?) {
        let urlString =  url
        if let urlString = urlString {
            let activityController = UIActivityViewController(activityItems: ["Hey! Check out this place!".localized(), urlString], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        } else {
            showAlert(title: "Sorry!".localized(), message: "I have no Google Maps Link for you to share!".localized())
        }
    }
    
    //Favorite
    func didTapFavoriteButton(placeId: String?) {
        CoreDataManager.deleteFavoriteFromList(placeId: placeId ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    //Website
    func didTapWebsiteButton(website: String?) {
        guard let url = URL(string: website ?? "") else {
            showAlert(title: "Sorry!".localized(), message: "I have no Website to show you!".localized())
            return }
        UIApplication.shared.open(url)
    }
    
    //Setup alert's messages
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    //Setup NavigationItemTitle
    func setNavigationItemTitle(title: String) {
        navigationItem.title = title
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "EurostileBold", size: 20) ?? UIFont(name: "", size: 0) as Any]
    }
    
    //Setup TabBarItemBadgeValue
    func setTabBarControllerItemBadgeValue(index: Int) {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        let tabItem = tabItems[index]
        tabItem.badgeValue = nil
    }
}
