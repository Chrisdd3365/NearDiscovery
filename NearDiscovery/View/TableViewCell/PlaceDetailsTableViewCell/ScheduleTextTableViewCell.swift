//
//  ScheduleTextTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 16/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class ScheduleTextTableViewCell: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var scheduleTextView: UITextView!
    
    //MARK: - Method
    func scheduleCellConfigure(placeDetails: PlaceDetails?) {
        scheduleTextView.text = convertIntoString(weekdayText: placeDetails?.openingHours?.weekdayText ?? ["No Schedule Available"])
    }
    
    //MARK: - Helper's method
    private func convertIntoString(weekdayText: [String]) -> String {
        var schedule = ""
        for weekdayString in weekdayText {
            schedule += weekdayString + "\n"
        }
        return schedule
    }
}
