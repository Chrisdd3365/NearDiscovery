//
//  Date.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import Foundation

extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) }
}
