//
//  DiscoverButtonTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 16/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

protocol DiscoverButtonCellDelegate {
    func didTapDiscover()
}

class DiscoverButtonTableViewCell: UITableViewCell {

    //MARK: - Outlet
    @IBOutlet weak var discoverLabel: UILabel!
    
    //MARK: - Properties
    var delegate: DiscoverButtonCellDelegate?
    
    @IBAction func discoverTapped(_ sender: UIButton) {
        delegate?.didTapDiscover()
    }
    
    //MARK: - Method
    func discoverLabelConfigure() {
        discoverLabel.font = UIFont(name: "EurostileBold", size: 19)
    }
}
