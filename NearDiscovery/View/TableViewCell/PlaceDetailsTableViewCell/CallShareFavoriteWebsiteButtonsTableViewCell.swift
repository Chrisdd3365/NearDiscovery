//
//  CallShareFavoriteWebsiteButtonsTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 16/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

protocol ButtonsActionsDelegate {
    func cleanPhoneNumberConverted(phoneNumber: String?) -> String
    func didTapCallButton()
    func didTapShareButton()
    func didTapFavoriteButton()
    func didUpdateFavoriteButtonImage() -> UIImage
    func didTapWebsiteButton()
}

class CallShareFavoriteWebsiteButtonsTableViewCell: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var favoriteButton: UIButton!
    
    //MARK: - Property
    var delegate: ButtonsActionsDelegate?
    
    //MARK: - Actions
    @IBAction func callButtonTapped(_ sender: UIButton) {
        delegate?.didTapCallButton()
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        delegate?.didTapShareButton()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.didTapFavoriteButton()
        favoriteButton.setImage(delegate?.didUpdateFavoriteButtonImage(), for: .normal)
    }
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        delegate?.didTapWebsiteButton()
    }
}
