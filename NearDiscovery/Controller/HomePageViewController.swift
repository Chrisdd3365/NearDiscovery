//
//  HomePageViewController.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 14/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import UIKit

extension Date {
    var hour: Int { return Calendar.current.component(.hour, from: self) }
}

class HomePageViewController: UIViewController {
    var timer = Timer()
    
    @IBOutlet var homePageView: HomePageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationScheduleTimer()
        changeBackground()
    }
    
    private func notificationScheduleTimer() {
        NotificationCenter.default.addObserver(self, selector: #selector(scheduleTimer), name:  UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func scheduleTimer() {
        timer = Timer(fireAt: Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 6..<21 ~= Date().hour ? 21 : 6), matchingPolicy: .nextTime)!, interval: 0, target: self, selector: #selector(changeBackground), userInfo: nil, repeats: false)
        print(timer.fireDate)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func changeBackground(){
        let dayBackgroundImage = UIImage(named: "landscapeday")
        let nightBackgroundImage = UIImage(named: "landscapenight")
        self.homePageView.backgroundImageView.image = 6..<21 ~= Date().hour ? dayBackgroundImage : nightBackgroundImage
        scheduleTimer()
    }
}

