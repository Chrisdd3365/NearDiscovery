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
    let regionInMeters: CLLocationDistance = 1000.0
    var directionsArray: [MKDirections] = []
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var travelTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupCoreLocation()
        showAnnotation(placeDetails: placeDetails)
    }
    
    @IBAction func showDirections(_ sender: UIButton) {
        getDirections(placeDetails: placeDetails)
    }
    
    @IBAction func centerUserButton(_ sender: Any) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
        
    private func showAnnotation(placeDetails: PlaceDetails) {
        let placeMarker = PlaceMarker(latitude: placeDetails.geometry.location.latitude, longitude: placeDetails.geometry.location.longitude, name: placeDetails.name)
        DispatchQueue.main.async {
            self.mapView.addAnnotation(placeMarker)
        }
    }
    //1
    private func getDestinationCoordinate(placeDetails: PlaceDetails) -> CLLocation {
        let latitude = placeDetails.geometry.location.latitude
        let longitude = placeDetails.geometry.location.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    //2
    private func createDirectionsRequest(from coordinate: CLLocationCoordinate2D, placeDetails: PlaceDetails) -> MKDirections.Request {
        let destinationCoordinate = getDestinationCoordinate(placeDetails: placeDetails).coordinate
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }
    //3
    private func getDirections(placeDetails: PlaceDetails) {
        guard let location = locationManager.location?.coordinate else { return }
        let request = createDirectionsRequest(from: location, placeDetails: placeDetails)
        let directions = MKDirections(request: request)
        resetMapView(directions: directions)
        
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else {
                self.showAlert(title: "Error", message: "no routes available for now!")
                return }
            
            for route in response.routes {
                //TODO: get steps into tableview?
                //let steps = route.steps
                let time = route.expectedTravelTime
                self.travelTimeLabel.text = "\(time / 60) min."
                let distance = route.distance
                self.distanceLabel.text = "\(distance) m."
                
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    //HELPER
    private func resetMapView(directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel()}
    }
    
    //DELEGATE CORE LOCATION
    private func setupCoreLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
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
        locationManager.stopUpdatingLocation()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        return renderer
    }
    //USER LOCATION
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

