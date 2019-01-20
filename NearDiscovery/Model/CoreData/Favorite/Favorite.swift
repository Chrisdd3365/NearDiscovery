//
//  Favorite.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 20/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import Foundation
import CoreData

public class Favorite: NSManagedObject {
    //MARK: - Property
    static var all: [Favorite] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let favorites = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return favorites
    }
}
