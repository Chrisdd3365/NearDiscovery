//
//  SecondMapViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 08/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

typealias tripletType = (first: CLLocation, second: CLLocation, third: Double)

class SecondMapViewController: UIViewController {
    var locationManager = CLLocationManager()
    var placeMarker: PlaceMarker?
    var locations = Location.all
    let regionInMeters: CLLocationDistance = 1000.0
    var directionsArray: [MKDirections] = []
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        setupCoreLocation()
        setupMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTabBarControllerItemBadgeValue()
        locations = Location.all
        locationsTableView.reloadData()
    }
    
    @IBAction func getDirections(_ sender: UIButton) {
     
    }
    
    @IBAction func centerOnUserLocation(_ sender: UIButton) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
    
    private func setNavigationBarTitle() {
        self.navigationItem.title = "Locations List"
    }
    
    private func setTabBarControllerItemBadgeValue() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        let tabItem = tabItems[1]
        tabItem.badgeValue = nil
    }
    
    private func saveContext() {
        do {
            try AppDelegate.viewContext.save()
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func addAnnotation(location: Location) {
        let placeMarker = PlaceMarker(latitude: location.latitude, longitude: location.longitude, name: location.name ?? "no name")
        DispatchQueue.main.async {
            self.mapView.addAnnotation(placeMarker)
        }
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
    
    ////
    var nodes = [CLLocation]()
    var cordes = [tripletType]()
    //1
    func convertLocationIntoCLLocation(locations: [Location]) -> CLLocation {
        for location in locations {
            let latitude = location.latitude
            let longitude = location.longitude
            
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        return CLLocation(latitude: 0, longitude: 0)
    }
    //2
    func addCLLocationsIntoNodesArray(locations: [Location]) -> [CLLocation] {
        nodes.append(convertLocationIntoCLLocation(locations: locations))
        
        return nodes
    }
    //3
    func creationCorde(locations: [Location]) {
        for i in 0...addCLLocationsIntoNodesArray(locations: locations).count - 1 {
            let node1 = addCLLocationsIntoNodesArray(locations: locations)[i]
            let node1Coordinate = node1.coordinate
            
            let newStartIndex = i + 1
            for j in newStartIndex...addCLLocationsIntoNodesArray(locations: locations).count {
                let node2 = addCLLocationsIntoNodesArray(locations: locations)[j]
                let node2Coordinate = node2.coordinate
                
                let distance = calculCout(node1: node1, node2: node2)
                let triplet: tripletType = (first: node1, second: node2, third: distance)
                cordes.append(triplet)
                
                getPathing(from: node1Coordinate, to: node2Coordinate, request: createDirectionsRequest(from: node1Coordinate, to: node2Coordinate))
            }
        }
    }
    private func createDirectionsRequest(from startingNodeCoordinate: CLLocationCoordinate2D, to nextNodeCoordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let startingNodeMapItem = MKMapItem(placemark: MKPlacemark(coordinate: startingNodeCoordinate))
        let nextNodeMapItem = MKMapItem(placemark: MKPlacemark(coordinate: nextNodeCoordinate))
        
        let request = MKDirections.Request()
        request.transportType = .walking
        request.source = startingNodeMapItem
        request.destination = nextNodeMapItem
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    //Helper's methods
    func calculCout(node1: CLLocation, node2: CLLocation) -> Double {
        let distance = node1.distance(from: node2)
        return distance
    }
//    func findSon(currentNode: CLLocation, path: [CLLocation]) -> [CLLocation] {
//        for c in corde {
//            
//        }
//        
//        return nodes
//    }
    //4
    func getPath(locations: [Location]) -> [CLLocation]? {
        var path = [CLLocation]()
        var currentNode = addCLLocationsIntoNodesArray(locations: locations)[0]
        while path.count < addCLLocationsIntoNodesArray(locations: locations).count {
            var nodeSons = [CLLocation]()
            var bestSon = nodeSons[0]
            var minCout = calculCout(node1: currentNode, node2: bestSon)
            for son in nodeSons {
                let cout = calculCout(node1: currentNode, node2: son)
                if cout < minCout {
                    minCout = cout
                    bestSon = son
                }
                path.append(bestSon)
                currentNode = bestSon
            }
        }
        return path
    }
    ////
    private func getPathing(from startingNodeCoordinate: CLLocationCoordinate2D, to nextNodeCoordinate: CLLocationCoordinate2D, request: MKDirections.Request) {
        let directions = MKDirections(request: request)
        resetMapView(directions: directions)
        
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else {
                self.showAlert(title: "Error", message: "no routes available for now!")
                return }
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                let optimalPath = self.getPath(locations: self.locations)
                if optimalPath != nil {
                    self.getPathing(from: startingNodeCoordinate, to: nextNodeCoordinate, request: request)
                }
            }
        }
    }
    
    private func resetMapView(directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel()}
    }
    
    
    
    
    
    
    
    
    
}

extension SecondMapViewController: CLLocationManagerDelegate {
    //USER LOCATION
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: false)
        locationManager.stopUpdatingLocation()
    }
}

extension SecondMapViewController: MKMapViewDelegate {
    //ZOOM ON USER LOCATION
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            print("zoom")
        }
    }
    //DRAW DIRECTIONS
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
            annotationView?.glyphText = "☝️"
            annotationView?.markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
            return annotationView
        }
        return nil
    }
}

extension SecondMapViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Hit the 'ADD ON MAP' button to add a location in your location list!"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = locationsTableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        
        let location = locations[indexPath.row]
        
        cell.selectionStyle = .none
        cell.locationCellConfigure(locationName: location.name ?? "no name", locationAddress: location.address ?? "no address available", rating: location.rating, imageURL: location.photoReference ?? "")

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AppDelegate.viewContext.delete(locations[indexPath.row])
            locations.remove(at: indexPath.row)
            saveContext()
            locationsTableView.beginUpdates()
            locationsTableView.deleteRows(at: [indexPath], with: .automatic)
            locationsTableView.endUpdates()
        }
    }
}

extension SecondMapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return locations.isEmpty ? 200 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addAnnotation(location: locations[indexPath.row])
    }
}
