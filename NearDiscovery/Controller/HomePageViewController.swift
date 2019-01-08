//
//  HomePageViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 14/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit
import CoreLocation

class HomePageViewController: UIViewController {
    let googlePlacesSearchService = GooglePlacesSearchService()
    let locationManager = CLLocationManager()
    var timer = Timer()
    var didFindUserLocation = true
    var places: [PlaceSearch] = []
 
    @IBOutlet var homePageView: HomePageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homePageView.nearbyDiscoveryButton.isEnabled = false
        locationServicesIsEnabled()
        notificationScheduleTimer()
        changeSetup()
    }

    private func toggleActivityIndicatorAndNearbyDiscoveryButton(shown: Bool) {
        homePageView.activityIndicator.isHidden = !shown
        homePageView.nearbyDiscoveryButton.isEnabled = !shown
    }
    
    private func fetchGooglePlacesData(location: CLLocation) {
        let keyword = "museum,monument"
        googlePlacesSearchService.getGooglePlacesSearchData(keyword: keyword, location: location) { (success, places) in
            self.toggleActivityIndicatorAndNearbyDiscoveryButton(shown: true)
            if success {
                self.toggleActivityIndicatorAndNearbyDiscoveryButton(shown: false)
                self.places = places.results
            } else {
                self.showAlert(title: "Error", message: "Google places API datas download failed!")
            }
        }
    }
    
    private func locationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        } else {
            showAlert(title: "Error! Location Services not enabled!", message: "We need your authorization!")
        }
    }
    //GET USER LOCATION AUTHORIZER STATUS
    private func getUserLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            updateUserLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func updateUserLocation() {
        didFindUserLocation = false
        if didFindUserLocation == false {
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    //DELEGATE CORELOCATION
    private func setupLocationManager() {
        locationManager.delegate = self
    }
    
    private func notificationScheduleTimer() {
        NotificationCenter.default.addObserver(self, selector: #selector(scheduleTimer), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func scheduleTimer() {
        timer = Timer(fireAt: Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 6..<21 ~= Date().hour ? 21 : 6), matchingPolicy: .nextTime)!, interval: 0, target: self, selector: #selector(changeSetup), userInfo: nil, repeats: false)
        print(timer.fireDate)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func changeSetup(){
        let dayBackgroundImage = UIImage(named: "daybackgroundimage")
        let nightBackgroundImage = UIImage(named: "nightbackgroundimage")
        
        self.homePageView.nearDiscoveryLabel.textColor = 6..<21 ~= Date().hour ?
            .black : .white
        self.homePageView.backgroundImageView.image = 6..<21 ~= Date().hour ? dayBackgroundImage : nightBackgroundImage
        scheduleTimer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showNearbySegue, let tabBarController = segue.destination as? UITabBarController,
            let navigationController = tabBarController.viewControllers?[0] as? UINavigationController, let nearbyPlacesListVC = navigationController.topViewController as? NearbyPlacesListViewController {
            nearbyPlacesListVC.places = places
        }
    }
}

extension HomePageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if didFindUserLocation == false {
            didFindUserLocation = true
            locationManager.stopUpdatingLocation()
        }
        fetchGooglePlacesData(location: userLocation)
    }
    //AUTHORIZER TO LOCATE USER
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getUserLocationAuthorizationStatus()
    }
}
    
    
    


