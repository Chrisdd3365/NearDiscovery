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
        homePageView.discoverLabel.font = UIFont(name: "EurostileBold", size: 19)
        homePageView.discoverLabel.textColor = .white
        locationServicesIsEnabled()
        notificationScheduleTimer()
        changeSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        homePageView.nearbyDiscoveryButton.isEnabled = false
        homePageView.discoverLabel.font = UIFont(name: "EurostileBold", size: 19)
        homePageView.discoverLabel.textColor = .white
        homePageView.searchTextField.text = nil
        locationServicesIsEnabled()
        notificationScheduleTimer()
        changeSetup()
        toggleActivityIndicator(shown: true)
    }
    
    //MARK: - Methods
    private func toggleActivityIndicator(shown: Bool) {
        homePageView.activityIndicator.isHidden = !shown
        homePageView.nearbyDiscoveryButton.isEnabled = !shown
    }
    
    private func keywordTextField() -> String {
        var keyword = ""
        guard let inputs = homePageView.searchTextField.text else { return "" }
        keyword = inputs
        return keyword
    }
    
    //Method to dismiss keyboard by tapping anywhere on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        fetchGooglePlacesData(keyword: keywordTextField())
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
    private func fetchGooglePlacesData(keyword: String) {
        let userLocation = CLLocation(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        
        googlePlacesSearchService.getGooglePlacesSearchData(keyword: keyword, location: userLocation) { (success, places) in
            self.toggleActivityIndicator(shown: true)
            if success {
                self.toggleActivityIndicator(shown: false)
                self.places = places.results
            } else {
                self.showAlert(title: "Sorry!".localized(), message: "I couldn't find what you want to discover for you!".localized())
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
        self.homePageView.nearDiscoveryLabel.textColor = 6..<21 ~= Date().hour ?
            .black : .white
        self.homePageView.backgroundColor = 6..<21 ~= Date().hour ? UIColor(displayP3Red: 47/255, green: 172/255, blue: 102/255, alpha: 1) : .black
        scheduleTimer()
    }
}

//MARK: - CoreLocation's methods
extension HomePageViewController {
    private func locationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        } else {
            showAlert(title: "Location Services not enabled!".localized(), message: "I need your authorization to show you cool places!".localized())
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
    //AUTHORIZER TO LOCATE USER
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getUserLocationAuthorizationStatus()
    }
}
