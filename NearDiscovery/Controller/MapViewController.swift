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
    var currentLocation: CLLocation = CLLocation(latitude: 42.361145, longitude: -71.057083)
    var searchRadius : Int = 2500
    
    
    var placesMarkers: [PlaceMarker] = []
    let regionInMeters: Double = 4000
    private var searchedTypes = ["bakery", "bar", "cafe", "supermarket", "restaurant"]
    var locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    lazy var geocoder = CLGeocoder()
    
  
    @IBOutlet weak var mapView: MKMapView!
    
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        locationServicesIsEnabled()
        getUserLocationAuthorizationStatus()
        fetchGoogleData(forLocation: currentLocation)
        
    }
    
    func fetchGoogleData(forLocation: CLLocation) {
        //guard let location = currentLocation else { return }
        googlePlacesService.getGooglePlacesData(forKeyword: "Starbucks", location: currentLocation, withinMeters: 2500) { (response) in

            self.printFirstFive(places: response.results)

        }
    }
    
    func printFirstFive(places: [Place]) {
        for place in places.prefix(20) {
            print("*******NEW PLACE********")
            let name = place.name
            let address = place.address
            let location = ("lat: \(place.geometry.location.latitude), lng: \(place.geometry.location.longitude)")
            guard let open = place.openingHours?.isOpen else {
                print("\(name) is located at \(address), \(location)")
                return
            }

            if open {
                print("\(name) is open, located at \(address), \(location)")
            } else {
                print("\(name) is closed, located at \(address), \(location)")
            }
        }
    }
    
    
    
    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
      //TODO
    }
    
    private func locationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            getUserLocationAuthorizationStatus()
            previousLocation = getUserAddress(for: mapView)
        } else {
            showAlert(title: "Location Services not enabled", message: "We need your authorization!")
        }
    }

    private func getUserLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            activateLocationServices()
        } else {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func activateLocationServices() {
        locationManager.startUpdatingLocation()
    }
    
    private func setupMapView() {
        mapView.delegate = self
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func getUserAddress(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
//    func loadPlaces(place: Place) {
//        let places = PlaceMarker(latitude: place.geometry.location.latitude, longitude: place.geometry.location.longitude, name: place.name)
//        placesMarkers.append(places)
//    }
//
//    private func addPlacesLocations(place: Place) {
//        loadPlaces(place: place)
//        mapView.addAnnotations(placesMarkers)
//    }

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
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getUserLocationAuthorizationStatus()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: false)
        }
    }

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


    
    
    
    



