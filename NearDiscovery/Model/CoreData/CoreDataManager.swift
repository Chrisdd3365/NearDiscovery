//
//  CoreDataManager.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 14/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    //MARK: - Methods
    static func saveLocation(placeDetails: PlaceDetails, place: PlaceSearch) {
        let location = Location(context: AppDelegate.viewContext)
        location.placeId = placeDetails.placeId
        location.photoReference = place.photos?[0].photoReference
        location.name = placeDetails.name
        location.address = placeDetails.address
        location.phoneNumber = placeDetails.internationalPhoneNumber
        location.rating = placeDetails.rating ?? 0.0
        location.openingHours = placeDetails.openingHours?.openNow ?? false
        location.latitude = placeDetails.geometry.location.latitude
        location.longitude = placeDetails.geometry.location.longitude
        
        saveContext()
    }
    
    static func saveContext() {
        do {
            try AppDelegate.viewContext.save()
        } catch let error as NSError {
            print(error)
        }
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
