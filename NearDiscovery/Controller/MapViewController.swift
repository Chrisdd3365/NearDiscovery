//
//  MapViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 14/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    private let googlePlacesService = GooglePlacesService()
    var locationManager = CLLocationManager()
    var placesMarkers: [PlaceMarker] = []
    let regionInMeters: CLLocationDistance = 2000.0
    
    //TBD
    private var searchedTypes = ["bakery", "bar", "cafe", "supermarket", "restaurant"]
    //TESTING LOCATION
    //var appleParkLocation: CLLocation = CLLocation(latitude: 37.33182, longitude: -122.03118)
  
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        locationServicesIsEnabled()
        getUserLocationAuthorizationStatus()
    }

    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
      //TODO
    }
    
    private func fetchGoogleData(forLocation: CLLocation) {
        let searchRadius = 2500
        googlePlacesService.getGooglePlacesData(forKeyword: "restaurant", location: forLocation, withinMeters: searchRadius) { (response) in
            self.showAnnotations(places: response.results)
        }
    }
    
    private func showAnnotations(places: [Place]) {
        for place in places {
            let placeMarker = PlaceMarker(latitude: place.geometry.location.latitude, longitude: place.geometry.location.longitude, name: place.name)
            placesMarkers.append(placeMarker)
            mapView.addAnnotations(placesMarkers)
        }
    }
    
    //    func printFirstFive(places: [Place]) {
    //        for place in places.prefix(20) {
    //            print("*******NEW PLACE********")
    //            let name = place.name
    //            let address = place.address
    //            let location = ("lat: \(place.geometry.location.latitude), lng: \(place.geometry.location.longitude)")
    //            guard let open = place.openingHours?.isOpen else {
    //                print("\(name) is located at \(address), \(location)")
    //                return
    //            }
    //
    //            if open {
    //                print("\(name) is open, located at \(address), \(location)")
    //            } else {
    //                print("\(name) is closed, located at \(address), \(location)")
    //            }
    //        }
    //    }
    
    private func locationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            getUserLocationAuthorizationStatus()
        } else {
            showAlert(title: "Location Services not enabled", message: "We need your authorization!")
        }
    }
//GET USER LOCATION AUTHORIZER STATUS
    private func getUserLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            activateLocationServices()
        } else {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    //ENABLE LOCATION SERVICES
    private func activateLocationServices() {
        locationManager.startUpdatingLocation()
    }
    //DELEGATE MAPKIT
    private func setupMapView() {
        mapView.delegate = self
    }
    //DELEGATE CORELOCATION
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //TBD
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.typesSegueIdentifier, let typesVC = segue.destination as? TypesViewController {
            typesVC.selectedTypes = searchedTypes
            typesVC.delegate = self as? TypesViewControllerDelegate
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: false)
        fetchGoogleData(forLocation: userLocation)
    }
    //AUTHORIZER TO LOCATE USER
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getUserLocationAuthorizationStatus()
    }
}

extension MapViewController: MKMapViewDelegate {
    //USER LOCATION
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: false)
        }
    }
    //ANNOTATIONS
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PlaceMarker") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PlaceMarker")
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.canShowCallout = true
        annotationView?.glyphText = "☝️"
        annotationView?.markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
        return annotationView
    }
}


    
    
    
    



