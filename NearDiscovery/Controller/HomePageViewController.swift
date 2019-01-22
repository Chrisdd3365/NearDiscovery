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
    //MARK: - Outlet
    @IBOutlet var homePageView: HomePageView!
    
    //MARK: - Properties
    let googlePlacesSearchService = GooglePlacesSearchService()
    let locationManager = CLLocationManager()
    var timer = Timer()
    var places: [PlaceSearch] = []
    //Boolean to avoid API being called twice by stopping to update user location
    var didFindUserLocation = true
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        homePageView.nearbyDiscoveryButton.isEnabled = false
        locationServicesIsEnabled()
        notificationScheduleTimer()
        changeSetup()
    }
    
    //MARK: - Methods
    private func toggleActivityIndicatorAndNearbyDiscoveryButton(shown: Bool) {
        homePageView.activityIndicator.isHidden = !shown
        homePageView.nearbyDiscoveryButton.isEnabled = !shown
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.showNearbySegue, let tabBarController = segue.destination as? UITabBarController,
            let navigationController = tabBarController.viewControllers?[0] as? UINavigationController, let nearbyPlacesListVC = navigationController.topViewController as? NearbyPlacesListViewController {
            nearbyPlacesListVC.places = places
        }
    }
}

//MARK: - API Fetch Google Places Search Data method
extension HomePageViewController {
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
}

//MARK: - Timer's methods
//To display different background's images, depends on the time of the day
extension HomePageViewController {
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
}

//MARK: - CoreLocation's methods
extension HomePageViewController {
    private func locationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        } else {
            showAlert(title: "Error! Location Services not enabled!", message: "We need your authorization!")
        }
    }

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
    
    private func setupLocationManager() {
        locationManager.delegate = self
    }
}

//MARK: - CoreLocationManagerDelegate's methods
extension HomePageViewController: CLLocationManagerDelegate {
    //GET USER LOCATION
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print(userLocation)
        if didFindUserLocation == false {
            didFindUserLocation = true
            locationManager.stopUpdatingLocation()
        }
        //API CALL
        fetchGooglePlacesData(location: userLocation)
    }
    //AUTHORIZER TO LOCATE USER
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getUserLocationAuthorizationStatus()
    }
}
    
    
    


