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
    @IBOutlet weak var mapUIView: MapView!
        
    //MARK: - Properties
    var locationManager = CLLocationManager()
    var placeDetails: PlaceDetails?
    var placeMarker: PlaceMarker?
    var favoritePlace: Favorite?
    let regionInMeters: CLLocationDistance = 1000.0
    var directionsArray: [MKDirections] = []
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupCoreLocation()
        setupAnnotation()
        setNavigationItemTitle(title: "Discover".localized())
    }
    
    //MARK: - Actions    
    @IBAction func centerUserButton(_ sender: UIButton) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
    
    @IBAction func automobileDirections(_ sender: UIButton) {
        setupGetDirections(sender: sender)
        setupButtonSetImage(automobileImage: "automobile", walkingImage: "noWalking")
        setupLabelColor(automobileLabelColor: UIColor(displayP3Red: 47/255, green: 172/255, blue: 102/255, alpha: 1), walkingLabelColor: .black)
    }
    
    @IBAction func walkingDirections(_ sender: UIButton) {
        setupGetDirections(sender: sender)
        setupButtonSetImage(automobileImage: "noAutomobile", walkingImage: "walking")
        setupLabelColor(automobileLabelColor: .black, walkingLabelColor: UIColor(displayP3Red: 47/255, green: 172/255, blue: 102/255, alpha: 1))
    }

    //MARK: - Methods
    //Delegate CoreLocation
    private func setupCoreLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    //Delegate MapKit
    private func setupMapView() {
        mapView.delegate = self
    }
}

//MARK: - Setup UI methods
extension MapViewController {
    //Setup SetImage's Buttons
    private func setupButtonSetImage(automobileImage: String, walkingImage: String) {
        mapUIView.automobileDirections.setImage(UIImage(named: automobileImage), for: .normal)
        mapUIView.walkingDirections.setImage(UIImage(named: walkingImage), for: .normal)
    }
    
    //Setup Label's Color
    private func setupLabelColor(automobileLabelColor: UIColor, walkingLabelColor: UIColor) {
        mapUIView.automobileLabel.textColor = automobileLabelColor
        mapUIView.walkingLabel.textColor = walkingLabelColor
    }
}

//MARK: - Annotation's methods
extension MapViewController {
    //Show Annotation
    private func showAnnotation(latitude: Double, longitude: Double, name: String) {
        let placeMarker = PlaceMarker(latitude: latitude, longitude: longitude, name: name)
        DispatchQueue.main.async {
            self.mapView.addAnnotation(placeMarker)
        }
    }
    
    //Setup Annotation
    private func setupAnnotation() {
        showAnnotation(latitude: placeDetails?.geometry.location.latitude ?? 0.0, longitude: placeDetails?.geometry.location.longitude ?? 0.0, name: placeDetails?.name ?? "No Name".localized())
        showAnnotation(latitude: favoritePlace?.latitude ?? 0.0, longitude: favoritePlace?.longitude ?? 0.0, name: favoritePlace?.name ?? "No Name".localized())
    }
}

//MARK: - Display 'Directions' methods
extension MapViewController  {
    //1
    private func getDestinationCoordinate(latitude: Double?, longitude: Double?) -> CLLocation {
        let latitude = latitude
        let longitude = longitude
    
        return CLLocation(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
    }
    
    //2
    private func createDirectionsRequest(from coordinate: CLLocationCoordinate2D, latitude: Double?, longitude: Double?, sender: UIButton) -> MKDirections.Request {
        let destinationCoordinate = getDestinationCoordinate(latitude: latitude, longitude: longitude).coordinate
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.requestsAlternateRoutes = true
        request.transportType = switchTransportType(request: request, sender: sender)
    
        return request
    }
    
    //3
    private func getDirections(latitude: Double?, longitude: Double?, sender: UIButton) {
        guard let location = locationManager.location?.coordinate else { return }
        let request = createDirectionsRequest(from: location, latitude: latitude, longitude: longitude, sender: sender)
        let directions = MKDirections(request: request)
        resetMapView(directions: directions)
        
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else {
                self.showAlert(title: "Sorry!".localized(), message: "No routes found!".localized())
                return }
            
            for route in response.routes {
                let time = route.expectedTravelTime / 60
                self.mapUIView.expectedTimeTravelLabel.text = String(format: "%2.f", time) + " min"
                
                let distance = route.distance / 1000
                self.mapUIView.distanceLabel.text = String(format: "%.2f", distance) + " km"
                
                if distance < 5000/100 {
                    self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                } else {
                    self.showAlert(title: "Sorry!".localized(), message: "No routes found!".localized())
                }
            }
        }
    }
    
    //Setup GetDirections
    private func setupGetDirections(sender: UIButton) {
        if let placeDetails = placeDetails {
            getDirections(latitude: placeDetails.geometry.location.latitude, longitude: placeDetails.geometry.location.longitude, sender: sender)
        } else if let favoritePlace = favoritePlace {
            getDirections(latitude: favoritePlace.latitude, longitude: favoritePlace.longitude, sender: sender)
        }
    }
    
    //MARK: - Helper's methods
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
    //User Location
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
    //Tracking User Location when he is moving on mapView
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        mapView.userTrackingMode = .followWithHeading
    }
    
    //Draw Polyline on mapView
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5
        return renderer
    }
    
    //Show annotations on mapView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        if let placeAnnotation = annotation as? PlaceMarker {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.AnnotationsIdentifiers.placeMarkerIdentifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: placeAnnotation, reuseIdentifier: Constants.AnnotationsIdentifiers.placeMarkerIdentifier)
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

