# Project 12 of DA IOS Path - Openclassroom

# NearDiscovery

## Description:

NearDiscovery is an iOS app developed on Swift 4.2. It's a travelling/tourism app.
His main purpose is to find and suggest places, based on the types of locations the user wishes to visit. 

## Main functionnalities:

- Search: To show a list of places to visit based on the user location, a radius of 30 km around the user and the types of locations.

- Locations: To allow the user to mark differents types of locations on a map and to get directions to these locations with user location as the starting point.

- Favorites: to allow the user to add or to remove a selected place from the list of the favorites places.

## Others functionnalities:

- Call: To allow the user to call the phone number of the selected place.

- Share: To allow the user to share a google maps url through different social networks.

- Website: To show the website of the selected place on the WebBrowser Safari.

## What I used:

- MVC pattern
- CoreData
- API rest request with GoogleMaps (Place Search, Place Details)

## Running the tests:
- UnitTesting API request with Double Fake URL Session and Fake Response Data.
- UnitTesting CoreData.
- UnitTesting PlaceMarker (Annotations on mapView).

## Requirements:

- iOS 12.0+
- Xcode 10.0+
- CocoaPods 
- CoreData

## Dependencies:

- SDWebImage 4.0
- Cosmos 18.0
