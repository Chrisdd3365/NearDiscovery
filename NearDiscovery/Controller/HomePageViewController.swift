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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(scheduleTimer), name:  UIApplication.didBecomeActiveNotification, object: nil)
        changeBackground()
    }
    
    @objc func scheduleTimer() {
        timer = Timer(fireAt: Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 6..<21 ~= Date().hour ? 21 : 6), matchingPolicy: .nextTime)!, interval: 0, target: self, selector: #selector(changeBackground), userInfo: nil, repeats: false)
        print(timer.fireDate)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        print("new background change scheduled at:", timer.fireDate.description(with: .current))
    }
    
    @objc func changeBackground(){
        self.view.backgroundColor =  6..<21 ~= Date().hour ? .yellow : .black
        scheduleTimer()
    }
}

