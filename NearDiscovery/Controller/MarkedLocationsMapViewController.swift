//
//  MarkedLocationsMapViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 18/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MarkedLocationsMapViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationsCollectionView: UICollectionView!
    
    //MARK: - Properties
    var locationManager = CLLocationManager()
    var placeMarker: PlaceMarker?
    var placesMarkers: [PlaceMarker] = []
    let regionInMeters: CLLocationDistance = 1000.0
    var directionsArray: [MKDirections] = []
    var locations = Location.all
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnnotations(locations: locations)
        setNavigationBarTitle()
        locationsCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupMapView()
        setupCoreLocation()
        setTabBarControllerItemBadgeValue()
        locations = Location.all
        locationsCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showAnnotations(locations: locations)
    }
    
    //MARK: - Actions
    @IBAction func getDirections(_ sender: UIButton) {
        convertLocationIntoCLLocation()
        creationCorde()
        allPathing()
    }
    
    @IBAction func centerOnUserLocation(_ sender: UIButton) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
    
    //MARK: - Methods
    private func showAnnotations(locations: [Location]) {
        for location in locations {
            let placeMarker = PlaceMarker(latitude: location.latitude, longitude: location.longitude, name: location.name ?? "")
            placesMarkers.append(placeMarker)
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.placesMarkers)
            }
        }
    }
    
    private func setNavigationBarTitle() {
        self.navigationItem.title = "Locations List"
    }
    
    private func setTabBarControllerItemBadgeValue() {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        let tabItem = tabItems[1]
        tabItem.badgeValue = nil
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
    private var nodes = [CLLocation]()
    private typealias tripletType = (first: CLLocation, second: CLLocation, third: Double)
    private var cordes = [tripletType]()
    
    
    
    
    
    //1
    func convertLocationIntoCLLocation() {
        for location in locations {
            let latitude = location.latitude
            let longitude = location.longitude

            nodes.append(CLLocation(latitude: latitude, longitude: longitude))
        }
    }
    //2
    func creationCorde() {
        for i in 0...nodes.count - 2 {
            let node1 = nodes[i]
            
            let newStartIndex = i + 1
            for j in newStartIndex...nodes.count - 1 {
                let node2 = nodes[j]
                
                let distance = calculCout(node1: node1, node2: node2)
                let triplet: tripletType = (first: node1, second: node2, third: distance)
                cordes.append(triplet)
            }
        }
    }

    //Helper's methods
    func calculCout(node1: CLLocation, node2: CLLocation) -> Double {
        let distance = node1.distance(from: node2)
        return distance
    }
    func getCout(node1: CLLocation, node2: CLLocation) -> Double{
        for c in cordes {
            if c.first == node1 && c.second == node2 {
                return c.third
            }
            if c.second == node1 && c.first == node2 {
                return c.third
            }
        }
        return 0
    }
    func findSon(currentNode: CLLocation, path: [CLLocation]) -> [CLLocation] {
        var nodeSons = [CLLocation]()
        for c in cordes {
            if c.first == currentNode && !path.contains(c.second) {
                nodeSons.append(c.second)
            }
            if c.second == currentNode && !path.contains(c.first) {
                nodeSons.append(c.first)
            }
        }
        return nodeSons
    }
    //4
    func getPath() -> [CLLocation] {
        var path = [CLLocation]()
        var currentNode = nodes[0]
        
        path.append(currentNode)
        print("début calcul path:")
        var sumDistance: Double = 0
        
        while path.count < nodes.count  {
            print(currentNode.coordinate)
            var nodeSons = findSon(currentNode: currentNode, path: path)
            var bestSon = nodeSons[0]
            var minCout = getCout(node1: currentNode, node2: bestSon)
            for son in nodeSons {
                let cout = getCout(node1: currentNode, node2: son)
                if cout < minCout {
                    minCout = cout
                    bestSon = son
                }
            }
            sumDistance += minCout
            path.append(bestSon)
            currentNode = bestSon
        }
        
        
        return checkBetterPath(firstPath: path, sumDistance: sumDistance)
    }
    func checkBetterPath(firstPath: [CLLocation], sumDistance: Double) -> [CLLocation] {
        
        var path = [CLLocation]()
        var currentNode = firstPath[2]
        path.append(nodes[0])
        path.append(currentNode)
        var sumDistanceCurrentPath = 0.0
        while path.count < nodes.count  {
            print(currentNode.coordinate)
            var nodeSons = findSon(currentNode: currentNode, path: path)
            var bestSon = nodeSons[0]
            var minCout = getCout(node1: currentNode, node2: bestSon)
            for son in nodeSons {
                let cout = getCout(node1: currentNode, node2: son)
                if cout < minCout {
                    minCout = cout
                    bestSon = son
                }
            }
            sumDistanceCurrentPath += minCout
            path.append(bestSon)
            currentNode = bestSon
        }
        if sumDistanceCurrentPath > sumDistance {
            return firstPath
        } else {
            return path
        }
    }
    
    
    
    ////
    private func getPathing(from startingNodeCoordinate: CLLocation, to nextNodeCoordinate: CLLocation) {
        let startingNodeMapItem = MKMapItem(placemark: MKPlacemark(coordinate: startingNodeCoordinate.coordinate))
        let nextNodeMapItem = MKMapItem(placemark: MKPlacemark(coordinate: nextNodeCoordinate.coordinate))
        
        let request = MKDirections.Request()
        request.transportType = .walking
        request.source = startingNodeMapItem
        request.destination = nextNodeMapItem
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        resetMapView(directions: directions)
        
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else {
                self.showAlert(title: "Error", message: "no routes available for now!")
                return }
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    private func allPathing() {
        var path = getPath()
        print(path.count)
        print(nodes.count)
        print(cordes.count)
        for i in 0...path.count - 2 {
            getPathing(from: path[i], to: path[i+1])
        }
    }
    
    private func resetMapView(directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel()}
    }
    private func addUserLocationInLocationsArray(userLocation: CLLocation) {
        nodes.append(userLocation)
    }
}

extension MarkedLocationsMapViewController: CLLocationManagerDelegate {
    //USER LOCATION
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: false)
        if nodes.isEmpty {
            nodes.append(location)
        } else {
            nodes[0] = location
        }
        locationManager.stopUpdatingLocation()
    }
}

extension MarkedLocationsMapViewController: MKMapViewDelegate {
    //ZOOM ON USER LOCATION
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let userLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: userLocation, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
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
            annotationView?.glyphText = "↓"
            annotationView?.markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
            return annotationView
        }
        return nil
    }
}

extension MarkedLocationsMapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = locationsCollectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath) as? LocationCollectionViewCell else {
            return UICollectionViewCell() }

        let location = locations[indexPath.row]

        cell.locationConfigure = location
        return cell
    }
}

//extension MarkedLocationsMapViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        for annotation in mapView.annotations {
//            let index = (self.mapView.annotations as NSArray).index(of: annotation)
//            if let annotation = annotation as? PlaceMarker, index == indexPath.row {
//                locationsCollectionView.reloadData()
//                locationsCollectionView.reloadItems(at: [indexPath])
//                mapView.reloadInputViews()
//
//                mapView.selectAnnotation(annotation, animated: true)
//
//
//                print(indexPath.row)
//                print(index)
//            }
//        }
//    }
//}
