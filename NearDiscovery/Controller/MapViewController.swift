//
//  MapViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    var locationManager = CLLocationManager()
    var placeDetails: PlaceDetails!
    var placeMarker: PlaceMarker?
    let regionInMeters: CLLocationDistance = 100.0

    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        showAnnotation(placeDetails: placeDetails)
    }
    
    private func showAnnotation(placeDetails: PlaceDetails) {
        let placeMarker = PlaceMarker(latitude: placeDetails.geometry.location.latitude, longitude: placeDetails.geometry.location.longitude, name: placeDetails.name)
        DispatchQueue.main.async {
            self.mapView.addAnnotation(placeMarker)
        }
    }
    //DELEGATE MAPKIT
    private func setupMapView() {
        mapView.delegate = self
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: false)
    }
}

extension MapViewController: MKMapViewDelegate {
    //USER LOCATION
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        if let userLocation = locationManager.location?.coordinate {
//            let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//            mapView.setRegion(region, animated: true)
//            print("zoom")
//        }
//    }
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            print("zoom")
        }
    }
    
    //ANNOTATIONS
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        if let placeAnnotation = annotation as? PlaceMarker {

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PlaceMarker") as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: placeAnnotation, reuseIdentifier: "PlaceMarker")
            } else {
                annotationView?.annotation = annotation
            }

            annotationView?.canShowCallout = true
            annotationView?.glyphText = "☝️"
            annotationView?.markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
            return annotationView
        }
        return nil
    }
}

