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
    @IBOutlet var markedLocationView: MarkedLocationView!
    
    //MARK: - Properties
    var locationManager = CLLocationManager()
    var placeMarker: PlaceMarker?
    var placesMarkers: [PlaceMarker] = []
    var regionHasBeenCentered = false
    let regionInMeters: CLLocationDistance = 1000.0
    var directionsArray: [MKDirections] = []
    var locations = Location.all
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnnotations(locations: locations)
        setNavigationItemTitle(title: "Marked Locations")
        locationsCollectionView.reloadData()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupMapView()
        setupCoreLocation()
        setTabBarControllerItemBadgeValue(index: 1)
        locations = Location.all
        locationsCollectionView.reloadData()
        secureDirectionsButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showAnnotations(locations: locations)
    }
    
    //MARK: - Actions
    @IBAction func getAutomobileDirections(_ sender: UIButton) {
        convertLocationIntoCLLocation()
        creationCorde()
        allPathing(sender: sender)
        secureDirectionsButtons()
        
        markedLocationView.automobileDirections.setImage(UIImage(named: "automobile"), for: .normal)
        markedLocationView.automobileLabel.textColor = UIColor(displayP3Red: 47/255, green: 172/255, blue: 102/255, alpha: 1)
        markedLocationView.walkingDirections.setImage(UIImage(named: "noWalking"), for: .normal)
        markedLocationView.walkingLabel.textColor = .black
    }
    
    @IBAction func getWalkingDirections(_ sender: UIButton) {
        convertLocationIntoCLLocation()
        creationCorde()
        allPathing(sender: sender)
        secureDirectionsButtons()
        
        markedLocationView.walkingDirections.setImage(UIImage(named: "walking"), for: .normal)
        markedLocationView.walkingLabel.textColor = UIColor(displayP3Red: 47/255, green: 172/255, blue: 102/255, alpha: 1)
        markedLocationView.automobileDirections.setImage(UIImage(named: "noAutomobile"), for: .normal)
        markedLocationView.automobileLabel.textColor = .black
    }
    
    @IBAction func centerOnUserLocation(_ sender: UIButton) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
    
    //MARK: - Methods
    private func secureDirectionsButtons() {
        if locations.isEmpty == true  {
            markedLocationView.automobileDirections.isEnabled = false
            markedLocationView.walkingDirections.isEnabled = false
            markedLocationView.automobileLabel.textColor = .gray
            markedLocationView.walkingLabel.textColor = .gray
        } else {
            markedLocationView.automobileDirections.isEnabled = true
            markedLocationView.walkingDirections.isEnabled = true
            markedLocationView.automobileLabel.textColor = .black
            markedLocationView.walkingLabel.textColor = .black
        }
    }
    
    private func showAnnotations(locations: [Location]) {
        for location in locations {
            let placeMarker = PlaceMarker(latitude: location.latitude, longitude: location.longitude, name: location.name ?? "")
            placesMarkers.append(placeMarker)
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.placesMarkers)
            }
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
        print(nodes.count)
        if nodes.count > 2 {
            return checkBetterPath(firstPath: path, sumDistance: sumDistance)
            
        } else {
            return path
        }
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
    private func getPathing(from startingNodeCoordinate: CLLocation, to nextNodeCoordinate: CLLocation, sender: UIButton) {
        let startingNodeMapItem = MKMapItem(placemark: MKPlacemark(coordinate: startingNodeCoordinate.coordinate))
        let nextNodeMapItem = MKMapItem(placemark: MKPlacemark(coordinate: nextNodeCoordinate.coordinate))
        
        let request = MKDirections.Request()
        request.transportType = switchTransportType(request: request, sender: sender)
        request.source = startingNodeMapItem
        request.destination = nextNodeMapItem
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        resetMapView(directions: directions)
        
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else {
                self.showAlert(title: "Sorry!", message: "No routes available!")
                return }
            for route in response.routes {
                let time = route.expectedTravelTime / 60
                self.markedLocationView.expectedTravelTimeLabel.text = String(format: "%2.f", time) + " min"
                
                let distance = route.distance / 1000
                self.markedLocationView.distanceLabel.text = String(format: "%.2f", distance) + " km"
                
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
    
    private func allPathing(sender: UIButton) {
        var path = getPath()
        for i in 0...path.count - 2 {
            getPathing(from: path[i], to: path[i+1], sender: sender)
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
    
    lazy var collectionView: UICollectionView = {
        locationsCollectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.identifier)
        return locationsCollectionView
    }()
    
    
}

extension MarkedLocationsMapViewController: CLLocationManagerDelegate {
    //USER LOCATION
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if !regionHasBeenCentered {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: false)
        if nodes.isEmpty {
            nodes.append(location)
        } else {
            nodes[0] = location
        }
            regionHasBeenCentered = true
        }
    }
}

extension MarkedLocationsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        mapView.userTrackingMode = .followWithHeading
    }
    
    
    
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

extension MarkedLocationsMapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = locationsCollectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as? LocationCollectionViewCell else {
            return UICollectionViewCell() }

        let location = locations[indexPath.row]
        cell.locationConfigure = location
        
        return cell
    }
}

extension MarkedLocationsMapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        for annotation in mapView.annotations {
            if annotation.coordinate.latitude == location.latitude && annotation.coordinate.longitude == location.longitude {
                locationsCollectionView.reloadData()
                mapView.reloadInputViews()
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
}

extension MarkedLocationsMapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionFooter) {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCollectionReusableView.identifier, for: indexPath) as! FooterCollectionReusableView
            return footerView
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return locations.isEmpty ? CGSize(width: view.frame.width, height: 100) : CGSize(width: 0, height: 0)
    }
}

extension MarkedLocationsMapViewController {
    private func setConstraints() {
        view.addSubview(collectionView)
        collectionView.setAnchors(top: locationsCollectionView.safeTopAnchor, leading: locationsCollectionView.safeLeadingAnchor, bottom: locationsCollectionView.bottomAnchor, trailing: locationsCollectionView.safeTrailingAnchor)
    }
}
