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
    
    private let placeDetailsServices = PlaceDetailsServices()
    var placesMarkers = [PlaceMarker]()
    private let searchRadius: Double = 1000.0
    let regionInMeters: Double = 200
    private var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    var locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    var previousLocation: CLLocation?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        locationServicesIsEnabled()
        getUserLocationAuthorizationStatus()
    }
    
    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
        //fetchNearbyPlaces(coordinate: mapView.reload())
    }
    
    func fetchGoogleData(location: CLLocationCoordinate2D) {
        placeDetailsServices.getNearPlacesCoordinates(location, radius: searchRadius, types: searchedTypes) { places in
            
        }
    }
    
    private func locationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            getUserLocationAuthorizationStatus()
            previousLocation = getUserAddress(for: mapView)
        } else {
            //TODO: Show alert
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
    
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        placeDetailsServices.getNearPlacesCoordinates(coordinate, radius: searchRadius, types: searchedTypes) { places in
                //mapView.addAnnotations(places)
        }
    }
    
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getUserAddress(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let _ = error {
                //TODO: show alert
                return
            }
            guard let placemark = placemarks?.first else {
                //TODO: show alert
                return }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber)" + " \(streetName)"
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.glyphText = ""
        annotationView?.markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
        return annotationView
    }
}
    
    
    
    
    
    



