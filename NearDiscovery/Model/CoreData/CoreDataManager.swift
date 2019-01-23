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
    //MARK: - Favorite CoreDataManager's methods
    static func saveFavorite(placeDetails: PlaceDetails?, place: PlaceSearch?) {
        let favorite = Favorite(context: AppDelegate.viewContext)
        
        favorite.placeId = placeDetails?.placeId
        favorite.photoReference = place?.photos?[0].photoReference
        favorite.name = placeDetails?.name
        favorite.address = placeDetails?.address
        favorite.phoneNumber = placeDetails?.internationalPhoneNumber
        favorite.website = placeDetails?.website
        favorite.url = placeDetails?.url
        favorite.schedule = convertIngredientsArrayIntoString(schedule: placeDetails?.openingHours?.weekdayText ?? ["No Schedule Available"])
        favorite.rating = placeDetails?.rating ?? 0.0
        favorite.openNow = placeDetails?.openingHours?.openNow ?? false
        favorite.latitude = placeDetails?.geometry.location.latitude ?? 0.0
        favorite.longitude = placeDetails?.geometry.location.longitude ?? 0.0
    
        saveContext()
    }
    //Helper's method
    static func convertIngredientsArrayIntoString(schedule: [String]) -> String {
        let scheduleArray = schedule.map{ String($0) }
        return scheduleArray.joined(separator: ", ")
    }
    
    static func deleteFavoriteFromList(placeId: String, context: NSManagedObjectContext = AppDelegate.viewContext) {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "placeId == %@", placeId)
        
        do {
            let favorites = try context.fetch(fetchRequest)
            for favorite in favorites {
                context.delete(favorite)
            }
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    //MARK: - Location CoreDataManager's methods
    static func saveLocation(placeDetails: PlaceDetails?, place: PlaceSearch?) {
        let location = Location(context: AppDelegate.viewContext)
        
        location.placeId = placeDetails?.placeId
        location.photoReference = place?.photos?[0].photoReference
        location.name = placeDetails?.name
        location.address = placeDetails?.address
        location.rating = placeDetails?.rating ?? 0.0
        location.openNow = placeDetails?.openingHours?.openNow ?? false
        location.latitude = placeDetails?.geometry.location.latitude ?? 0.0
        location.longitude = placeDetails?.geometry.location.longitude ?? 0.0
        
        saveContext()
    }
    
    static func saveLocationFromFavorite(favoritePlace: Favorite?) {
        let location = Location(context: AppDelegate.viewContext)
        
        location.placeId = favoritePlace?.placeId
        location.photoReference = favoritePlace?.photoReference
        location.name = favoritePlace?.name
        location.address = favoritePlace?.address
        location.rating = favoritePlace?.rating ?? 0.0
        location.openNow = favoritePlace?.openNow ?? false
        location.latitude = favoritePlace?.latitude ?? 0.0
        location.longitude = favoritePlace?.longitude ?? 0.0
        
        saveContext()
    }
    
    static func deleteLocationFromList(placeId: String, context: NSManagedObjectContext = AppDelegate.viewContext) {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "placeId == %@", placeId)

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
    
    //MARK: - Helper's methods
    static func saveContext() {
        do {
            try AppDelegate.viewContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Location.fetchRequest())
        let _ = try? viewContext.execute(deleteRequest)
    }
}
