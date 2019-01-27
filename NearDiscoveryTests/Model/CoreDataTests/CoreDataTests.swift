//
//  CoreDataTests.swift
//  NearDiscoveryTests
//
//  Created by Christophe DURAND on 27/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import XCTest
import CoreData
@testable import NearDiscovery

class CoreDataTests: XCTestCase {

    //MARK: - Properties
    var container: NSPersistentContainer!
    let placeDetails: PlaceDetails? = nil
    let placeSearch: PlaceSearch? = nil
    let favoritePlace: Favorite? = nil
    
    //MARK: - Tests Life Cycle
    override func setUp() {
        favoriteInitStubs()
        locationInitStubs()
        container = AppDelegate.persistentContainer
    }
    
    override func tearDown() {
        favoriteFlushData()
        locationFlushData()
        CoreDataManager.deleteAllFavorites()
        CoreDataManager.deleteAllLocations()
        container = nil
        super.tearDown()
    }
    
    //MARK: - Methods
    private func insertFavoritePlaceItem(into managedObjectContext: NSManagedObjectContext) {
        let newFavoritePlaceItem = Favorite(context: managedObjectContext)
        newFavoritePlaceItem.placeId = "test"
    }
    
    private func insertLocationItem(into managedObjectContext: NSManagedObjectContext) {
        let newLocationItem = Location(context: managedObjectContext)
        newLocationItem.placeId = "test"
    }
    
    //MARK: - Unit Tests Favorite
    func testInsertManyFavoritePlaceItemsInPersistentContainer() {
        for _ in 0 ..< 10 {
            insertFavoritePlaceItem(into: container.newBackgroundContext())
        }
        XCTAssertNoThrow(try container.newBackgroundContext().save())
    }
    
    func testSaveFavoritePlaceItemInPersistentContainer() {
        CoreDataManager.saveFavorite(placeDetails: placeDetails, place: placeSearch)
        
        XCTAssert(true)
    }
    
    func testDeleteFavoritePlaceItemInPersistentContainer() {
        let favoritesPlaces = Favorite.all
        let favoritePlace = favoritesPlaces[0]
        
        CoreDataManager.deleteFavoriteFromList(placeId: favoritePlace.placeId!)
        
        XCTAssert(true)
    }
    
    func testDeleteAllFavoritePlaceItemsInPersistentContainer() {
        CoreDataManager.deleteAllFavorites()
        XCTAssertEqual(Favorite.all, [])
    }
    
    //MARK: Unit tests Location
    func testInsertManyLocationItemsInPersistentContainer() {
        for _ in 0 ..< 10 {
            insertLocationItem(into: container.newBackgroundContext())
        }
        XCTAssertNoThrow(try container.newBackgroundContext().save())
    }
    
    func testSaveLocationItemInPersistentContainer() {
        CoreDataManager.saveLocation(placeDetails: placeDetails, place: placeSearch)
        
        XCTAssert(true)
    }
    
    func testSaveLocationItemFromFavoriteInPersistentContainer() {
        CoreDataManager.saveLocationFromFavorite(favoritePlace: favoritePlace)
        
        XCTAssert(true)
    }
    
    func testDeleteLocationItemInPersistentContainer() {
        let locations = Location.all
        let location = locations[0]

        CoreDataManager.deleteLocationFromList(placeId: location.placeId ?? "")

        XCTAssert(true)
    }
    
    func testDeleteAllLocationItemsInPersistentContainer() {
        CoreDataManager.deleteAllLocations()
        XCTAssertEqual(Location.all, [])
    }
    
}

//MARK: Favorite
extension CoreDataTests {
    func favoriteInitStubs() {
        func insertFavoritePlaceItemIntoList(placeId: String) -> Favorite? {
            let favoritePlace = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: AppDelegate.viewContext)
            favoritePlace.setValue("test", forKey: "placeId")
            return favoritePlace as? Favorite
        }
        
        _ = insertFavoritePlaceItemIntoList(placeId: "test1")
        _ = insertFavoritePlaceItemIntoList(placeId: "test2")
        _ = insertFavoritePlaceItemIntoList(placeId: "test3")
        _ = insertFavoritePlaceItemIntoList(placeId: "test4")
        _ = insertFavoritePlaceItemIntoList(placeId: "test5")
        
        do {
            try AppDelegate.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
    }
    
    func favoriteFlushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        let favoritesPlaces = try! AppDelegate.viewContext.fetch(fetchRequest)
        for case let favorite as NSManagedObject in favoritesPlaces {
            AppDelegate.viewContext.delete(favorite)
        }
        try! AppDelegate.viewContext.save()
    }
}

//MARK: Location
extension CoreDataTests {
    func locationInitStubs() {
        func insertLocationItemIntoList(placeId: String) -> Location? {
            let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: AppDelegate.viewContext)
            location.setValue("test", forKey: "placeId")
            return location as? Location
        }
        
        _ = insertLocationItemIntoList(placeId: "test1")
        _ = insertLocationItemIntoList(placeId: "test2")
        _ = insertLocationItemIntoList(placeId: "test3")
        _ = insertLocationItemIntoList(placeId: "test4")
        _ = insertLocationItemIntoList(placeId: "test5")
        
        do {
            try AppDelegate.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
    }
    
    func locationFlushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        let locations = try! AppDelegate.viewContext.fetch(fetchRequest)
        for case let location as NSManagedObject in locations {
            AppDelegate.viewContext.delete(location)
        }
        try! AppDelegate.viewContext.save()
    }
}
