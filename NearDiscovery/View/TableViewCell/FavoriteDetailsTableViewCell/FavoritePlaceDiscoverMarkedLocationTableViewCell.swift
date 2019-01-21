//
//  FavoritePlaceDiscoverMarkedLocationTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 20/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class FavoritePlaceDiscoverMarkedLocationTableViewCell: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var discoverLabel: UILabel!
    
    //MARK: - Method
    func discoverLabelConfigure() {
        discoverLabel.font = UIFont(name: "EurostileBold", size: 12)
    }
}
