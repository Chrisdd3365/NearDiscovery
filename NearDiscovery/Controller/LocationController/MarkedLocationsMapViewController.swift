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
    @IBOutlet weak var removeAllLocationsButton: UIButton!
    
    //MARK: - Properties
    var locationManager = CLLocationManager()
    var placesMarkers: [PlaceMarker] = []
    var regionHasBeenCentered = false
    let regionInMeters: CLLocationDistance = 1000.0
    var directionsArray: [MKDirections] = []
    var locations = Location.all
    
    //CollectionView's property
    lazy var collectionView: UICollectionView = {
        locationsCollectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.identifier)
        return locationsCollectionView
    }()
    
    //TSP's properties
    private var nodes = [CLLocation]()
    private typealias LocationsDistance = (firstLocation: CLLocation, secondLocation: CLLocation, distance: Double)
    private var lines = [LocationsDistance]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnnotations(locations: locations)
        setNavigationItemTitle(title: "Marked Locations".localized())
        setConstraints()
        setupLeftBarButtonItem()
        locationsCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupMapView()
        setupCoreLocation()
        setTabBarControllerItemBadgeValue(index: 1)
        locations = Location.all
        locationsCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showAnnotations(locations: locations)
        secureDirectionsButtons()
        labelIsGreen()
    }
    
    //MARK: - SetEditing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        removeAllLocationsButton.isEnabled = editing
    }
    
    //MARK: - Actions
    @IBAction func getAutomobileDirections(_ sender: UIButton) {
        convertLocationIntoCLLocation()
        createLine()
        getAllPaths(sender: sender)
        secureDirectionsButtons()
        setupButtonSetImage(automobileImage: "automobile", walkingImage: "noWalking")
        setupLabelColor(automobileLabelColor: UIColor(displayP3Red: 47/255, green: 172/255, blue: 102/255, alpha: 1), walkingLabelColor: .black)
    }
    
    @IBAction func getWalkingDirections(_ sender: UIButton) {
        convertLocationIntoCLLocation()
        createLine()
        getAllPaths(sender: sender)
        secureDirectionsButtons()
        setupButtonSetImage(automobileImage: "noAutomobile", walkingImage: "walking")
        setupLabelColor(automobileLabelColor: .black, walkingLabelColor: UIColor(displayP3Red: 47/255, green: 172/255, blue: 102/255, alpha: 1))
    }
    
    @IBAction func centerOnUserLocation(_ sender: UIButton) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
    
    @IBAction func removeAllLocations(_ sender: UIButton) {
        deleteAllFromCoreData()
        deleteAllFromNodesArray()
        deleteAllAnnotationsAndOverlays()
        locationsCollectionView.reloadData()
        setupButtonSetImage(automobileImage: "noAutomobile", walkingImage: "noWalking")
        setupLabelColor(automobileLabelColor: .black, walkingLabelColor: .black)
        buttonIsEnabledStateSetup(isEnabled: false)
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
extension MarkedLocationsMapViewController {
    //Setup LeftBarButtonItem
    private func setupLeftBarButtonItem() {
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    //Setup SetImage's Buttons
    private func setupButtonSetImage(automobileImage: String, walkingImage: String) {
        markedLocationView.automobileDirections.setImage(UIImage(named: automobileImage), for: .normal)
        markedLocationView.walkingDirections.setImage(UIImage(named: walkingImage), for: .normal)
    }
    
    //Setup Label's Color
    private func setupLabelColor(automobileLabelColor: UIColor, walkingLabelColor: UIColor) {
        markedLocationView.automobileLabel.textColor = automobileLabelColor
        markedLocationView.walkingLabel.textColor = walkingLabelColor
    }
    
    //Setup isEnabled buttons state
    private func buttonIsEnabledStateSetup(isEnabled: Bool) {
        markedLocationView.automobileDirections.isEnabled = isEnabled
        markedLocationView.walkingDirections.isEnabled = isEnabled
    }
    
    //Setup labels color in green when going back and forth ViewControllers
    private func labelIsGreen() {
        if markedLocationView.automobileDirections.currentImage == UIImage(named: "automobile") {
            markedLocationView.automobileLabel.textColor = UIColor(displayP3Red: 47/255, green: 172/255, blue: 102/255, alpha: 1)
        }
        if markedLocationView.walkingDirections.currentImage == UIImage(named: "walking") {
            markedLocationView.walkingLabel.textColor = UIColor(displayP3Red: 47/255, green: 172/255, blue: 102/255, alpha: 1)
        }
    }
    
    //Avoid useless inputs from the user
    private func secureDirectionsButtons() {
        if locations.isEmpty == true  {
            buttonIsEnabledStateSetup(isEnabled: false)
            setupLabelColor(automobileLabelColor: .gray, walkingLabelColor: .gray)
        } else {
            buttonIsEnabledStateSetup(isEnabled: true)
            setupLabelColor(automobileLabelColor: .black, walkingLabelColor: .black)
        }
    }
}

//MARK: - Delete All methods
extension MarkedLocationsMapViewController {
    //Delete All Locations from CoreData
    private func deleteAllFromCoreData() {
        locations.removeAll()
        CoreDataManager.deleteAllLocations()
        CoreDataManager.saveContext()
    }
    
    //Delete All Nodes
    private func deleteAllFromNodesArray() {
        nodes.removeAll()
        let userLocation = CLLocation(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        nodes.append(userLocation)
    }
    
    //Delete All Annotations and Overlays
    private func deleteAllAnnotationsAndOverlays() {
        placesMarkers.removeAll()
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.removeOverlays(mapView.overlays)
    }
}

//MARK: - Annotation's method
extension MarkedLocationsMapViewController {
    //Show annotations
    private func showAnnotations(locations: [Location]) {
        for location in locations {
            let placeMarker = PlaceMarker(latitude: location.latitude, longitude: location.longitude, name: location.name ?? "")
            placesMarkers.append(placeMarker)
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.placesMarkers)
            }
        }
    }
}

//MARK: - Travelling Salesman Problem's (TSP) methods
extension MarkedLocationsMapViewController {
    //MARK: - TSP Algorithm's methods
    //1
    func convertLocationIntoCLLocation() {
        for location in locations {
            let latitude = location.latitude
            let longitude = location.longitude
            nodes.append(CLLocation(latitude: latitude, longitude: longitude))
        }
    }
    
    // We need to create the cords that link the nodes together.
    // Here, if A is linked to B , B is also Linked to A i.e. (A,B) and (B,A) is the same we don't need to specifiy the two link
    func createLine() {
        // We need to Link the elements of the array without the same pair twice
        // the folowing procedures implements this particularity.
        
        // Exemple [ A B C D E ]
        for i in 0...nodes.count - 2 {
            
            let firstNode = nodes[i]
            let newStartIndex = i + 1
            // for i = 0 , j go to 1 to 4
            // so we got the folowing association during the itération below
            // (A-B) (A-C) (A-D) (A-E)
            // Then for i = 1 , j go to 2 to 4
            // (B-C) (B-D) (B-E)
            // Then for i = 2 , j go to 3 to 4
            // (C-D) (C-E)
            // Then for i = 3 , j go to 4 to 4
            // (D-E)
            for j in newStartIndex...nodes.count - 1 {

                let secondNode = nodes[j]
                let distance = calculateDistance(firstNode: firstNode, secondNode: secondNode)
                let locationDistance: LocationsDistance = (firstLocation: firstNode, secondLocation: secondNode, distance: distance)
                lines.append(locationDistance)
            }
        }
    }
    
    //3
    func findSon(currentNode: CLLocation, path: [CLLocation]) -> [CLLocation] {
        var nodeSons = [CLLocation]()
        for line in lines {
            if line.firstLocation == currentNode && !path.contains(line.secondLocation) {
                nodeSons.append(line.secondLocation)
            }
            if line.secondLocation == currentNode && !path.contains(line.firstLocation) {
                nodeSons.append(line.firstLocation)
            }
        }
        return nodeSons
    }
    
    //4
    func getPath() -> [CLLocation] {
        var path = [CLLocation]()
        var distanceSum: Double = 0
        var currentNode = nodes[0]
        
        path.append(currentNode)
        
        while path.count < nodes.count  {
            var nodeSons = findSon(currentNode: currentNode, path: path)
            var bestSon = nodeSons[0]
            var distanceMin = getDistance(firstNode: currentNode, secondNode: bestSon)
            
            for nodeSon in nodeSons {
                let distance = getDistance(firstNode: currentNode, secondNode: nodeSon)
                if distance < distanceMin {
                    distanceMin = distance
                    bestSon = nodeSon
                }
            }
            distanceSum += distanceMin
            path.append(bestSon)
            currentNode = bestSon
        }
        
        if nodes.count > 2 {
            return checkBetterPath(firstPath: path, distanceSum: distanceSum)
            
        } else {
            return path
        }
    }
    
    //5
    func checkBetterPath(firstPath: [CLLocation], distanceSum: Double) -> [CLLocation] {
        var path = [CLLocation]()
        var currentNode = firstPath[2]
        var distanceSumCurrentPath = 0.0
        
        path.append(nodes[0])
        path.append(currentNode)
        
        while path.count < nodes.count  {
            var nodeSons = findSon(currentNode: currentNode, path: path)
            var bestSon = nodeSons[0]
            var distanceMin = getDistance(firstNode: currentNode, secondNode: bestSon)
            
            for son in nodeSons {
                let distance = getDistance(firstNode: currentNode, secondNode: son)
                if distance < distanceMin {
                    distanceMin = distance
                    bestSon = son
                }
            }
            distanceSumCurrentPath += distanceMin
            path.append(bestSon)
            currentNode = bestSon
        }
        if distanceSumCurrentPath > distanceSum {
            return firstPath
        } else {
            return path
        }
    }
    
    //6
    private func getAllPaths(sender: UIButton) {
        var path = getPath()
        for i in 0...path.count - 2 {
            getDirections(from: path[i], to: path[i+1], sender: sender)
        }
    }
    
    //Helper's methods
    func calculateDistance(firstNode: CLLocation, secondNode: CLLocation) -> Double {
        let distance = firstNode.distance(from: secondNode)
        return distance
    }
    
    func getDistance(firstNode: CLLocation, secondNode: CLLocation) -> Double{
        for line in lines {
            if line.firstLocation == firstNode && line.secondLocation == secondNode {
                return line.distance
            }
            if line.secondLocation == firstNode && line.firstLocation == secondNode {
                return line.distance
            }
        }
        return 0
    }
    
    //MARK: - Request/Directions to display on mapView
    private func createDirectionsRequest(from startingNodeMapItem: MKMapItem, to nextNodeMapItem: MKMapItem, sender: UIButton ) -> MKDirections.Request {
        let request = MKDirections.Request()
        request.transportType = switchTransportType(request: request, sender: sender)
        request.source = startingNodeMapItem
        request.destination = nextNodeMapItem
        request.requestsAlternateRoutes = false
        
        return request
    }
    
    private func getDirections(from startingNodeCoordinate: CLLocation, to nextNodeCoordinate: CLLocation, sender: UIButton) {
        let startingNodeMapItem = MKMapItem(placemark: MKPlacemark(coordinate: startingNodeCoordinate.coordinate))
        let nextNodeMapItem = MKMapItem(placemark: MKPlacemark(coordinate: nextNodeCoordinate.coordinate))
        let directions = MKDirections(request: createDirectionsRequest(from: startingNodeMapItem, to: nextNodeMapItem, sender: sender))
        
        resetMapView(directions: directions)
        
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else {
                self.showAlert(title: "Sorry!".localized(), message: "No routes found!".localized())
                return }
            
            for route in response.routes {
                let distance = route.distance / 1000
                
                if distance < 5000/100 {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                } else {
                    self.showAlert(title: "Sorry!".localized(), message: "No routes found!".localized())
                }
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

//MARK: - CoreLocationManagerDelegate's method
extension MarkedLocationsMapViewController: CLLocationManagerDelegate {
    //User Location
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

//MARK: - MapViewDelegate's methods
extension MarkedLocationsMapViewController: MKMapViewDelegate {
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

//MARK: - CollectionViewDataSource's methods
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

//MARK: - CollectionViewDelegate's method
extension MarkedLocationsMapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            let location = locations[indexPath.row]
            for annotation in mapView.annotations {
                if annotation.coordinate.latitude == location.latitude && annotation.coordinate.longitude == location.longitude {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
}

//MARK: - CollectionViewDelegateFlowLayout's methods
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

//MARK: - SetConstraints method
extension MarkedLocationsMapViewController {
    private func setConstraints() {
        view.addSubview(collectionView)
        collectionView.setAnchors(top: locationsCollectionView.safeTopAnchor, leading: locationsCollectionView.safeLeadingAnchor, bottom: locationsCollectionView.bottomAnchor, trailing: locationsCollectionView.safeTrailingAnchor)
    }
}
