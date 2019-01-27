//
//  String.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 27/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
