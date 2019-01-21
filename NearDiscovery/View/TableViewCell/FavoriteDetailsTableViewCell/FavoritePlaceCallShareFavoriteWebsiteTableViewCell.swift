//
//  FavoritePlaceCallShareFavoriteWebsiteTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 20/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

protocol FavoriteDetailsButtonsActionsDelegate {
    func cleanPhoneNumberConverted(phoneNumber: String?) -> String
    func didTapCallButton()
    func didTapShareButton()
    func didTapFavoriteButton()
    func didTapWebsiteButton()
}

class FavoritePlaceCallShareFavoriteWebsiteTableViewCell: UITableViewCell {
    //MARK: - Property:
    var delegate: FavoriteDetailsButtonsActionsDelegate?
    
    //MARK: - Actions:
    @IBAction func callButtonTapped(_ sender: UIButton) {
        delegate?.didTapCallButton()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        delegate?.didTapShareButton()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.didTapFavoriteButton()
    }
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        delegate?.didTapWebsiteButton()
    }
}
