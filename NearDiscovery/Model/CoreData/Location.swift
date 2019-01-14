//
//  Location.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 08/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import Foundation
import CoreData

public class Location: NSManagedObject {
    //MARK: - Property
    static var all: [Location] {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        guard let locations = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return locations
    }
}
