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
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var labelsView: LabelsView!
    @IBOutlet weak var automobileDirectionsButton: UIButton!
    @IBOutlet weak var walkingDirectionsButton: UIButton!
    
    //MARK: - Properties
    var locationManager = CLLocationManager()
    var placeDetails: PlaceDetails!
    var placeMarker: PlaceMarker?
    var locations = Location.all
    let regionInMeters: CLLocationDistance = 1000.0
    var directionsArray: [MKDirections] = []
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupCoreLocation()
        showAnnotation(placeDetails: placeDetails)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        setTabBarControllerItemBadgeValue()
//    }
    
    //MARK: - Actions    
    @IBAction func centerUserButton(_ sender: UIButton) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
    
    @IBAction func automobileDirections(_ sender: UIButton) {
        getDirections(placeDetails: placeDetails, sender: sender)
        sender.isSelected = true
    }
    
    @IBAction func walkingDirections(_ sender: UIButton) {
        getDirections(placeDetails: placeDetails, sender: sender)
    }
    
    //MARK: - Methods
//    private func setTabBarControllerItemBadgeValue() {
//        guard let tabItems = tabBarController?.tabBar.items else { return }
//        let tabItem = tabItems[1]
//        tabItem.badgeValue = nil
//    }
    
    //TODO: HANDLE SELECTED STATE
//    func myButtonTapped(){
//        if myButton.isSelected == true {
//            myButton.isSelected = false
//            myButton.setImage(UIImage(named : "unselectedImage"), forState: UIControlState.Normal)
//        }else {
//            myButton.isSelected = true
//            myButton.setImage(UIImage(named : "selectedImage"), forState: UIControlState.Normal)
//        }
//    }
    
    private func showAnnotation(placeDetails: PlaceDetails) {
        let placeMarker = PlaceMarker(latitude: placeDetails.geometry.location.latitude, longitude: placeDetails.geometry.location.longitude, name: placeDetails.name)
        DispatchQueue.main.async {
            self.mapView.addAnnotation(placeMarker)
        }
    }
    
//    func addAnnotation(location: Location) {
//        let placeMarker = PlaceMarker(latitude: location.latitude, longitude: location.longitude, name: location.name ?? "no name")
//        DispatchQueue.main.async {
//            self.mapView.addAnnotation(placeMarker)
//        }
//    }
    
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

//MARK: - Display 'Directions' methods
extension MapViewController  {
    private func getDestinationCoordinate(placeDetails: PlaceDetails) -> CLLocation {
        let latitude = placeDetails.geometry.location.latitude
        let longitude = placeDetails.geometry.location.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    private func createDirectionsRequest(from coordinate: CLLocationCoordinate2D, placeDetails: PlaceDetails, sender: UIButton) -> MKDirections.Request {
        let destinationCoordinate = getDestinationCoordinate(placeDetails: placeDetails).coordinate
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.requestsAlternateRoutes = true
        request.transportType = switchTransportType(request: request, sender: sender)
    
        return request
    }
    
    private func getDirections(placeDetails: PlaceDetails, sender: UIButton) {
        guard let location = locationManager.location?.coordinate else { return }
        let request = createDirectionsRequest(from: location, placeDetails: placeDetails, sender: sender)
        let directions = MKDirections(request: request)
        resetMapView(directions: directions)
        
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else {
                self.showAlert(title: "Error", message: "No routes available for now!")
                return }
            
            for route in response.routes {
                let time = route.expectedTravelTime / 60
                self.labelsView.expectedTimeTravelLabel.text = String(format: "%2.f", time) + " Min"
                
                let distance = route.distance / 1000
                self.labelsView.distanceLabel.text = String(format: "%.2f", distance) + " Km"
                
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    //Helper's methods
    private func switchTransportType(request: MKDirections.Request, sender: UIButton) -> MKDirectionsTransportType {
        var transportType = request.transportType
        switch sender.tag {
        case 1:
            transportType = .automobile
        case 2:
            transportType = .walking
        default:
            break
        }
        return transportType
    }
    
    private func resetMapView(directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel()}
    }
}

//MARK: - CoreLocationManagerDelegate's methods
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: false)
        locationManager.stopUpdatingLocation()
    }
}

//MARK: - MapViewDelegate's methods
extension MapViewController: MKMapViewDelegate {
//    //USER LOCATION
//    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//        if let userLocation = locationManager.location?.coordinate {
//            let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//            mapView.setRegion(region, animated: true)
//        }
//    }
    
    //POLYLINE
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        return renderer
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
            annotationView?.glyphText = "↓"
            annotationView?.markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
            return annotationView
        }
        return nil
    }
}
