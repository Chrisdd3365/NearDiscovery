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
    static var all: [Location] {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        guard let locations = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return locations
    }
    
    static func deleteLocationFromList(placeId: String, context: NSManagedObjectContext = AppDelegate.viewContext) {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "placeid == %@", placeId)
        
        do {
            let locations = try context.fetch(fetchRequest)
            for location in locations {
                context.delete(location)
            }
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Location.fetchRequest())
        let _ = try? viewContext.execute(deleteRequest)
    }
}
