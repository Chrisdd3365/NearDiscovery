//
//  ScheduleTextViewOpenStateLabelTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 16/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class ScheduleTextViewOpenStateLabelTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var placeDetailsScheduleTextView: UITextView!
    @IBOutlet weak var placeDetailsOpenStateLabel: UILabel!
    
    //MARK: - Method
    func scheduleOpenStateCellConfigure(placeDetails: PlaceDetails?) {
        placeDetailsScheduleTextView.text = convertIntoString(weekdayText: placeDetails?.openingHours?.weekdayText ?? ["No Schedule Available"])
        if placeDetails?.openingHours?.openNow == true {
            placeDetailsOpenStateLabel.text = "Open"
            placeDetailsOpenStateLabel.backgroundColor = UIColor.init(red: 0/255, green: 144/255, blue: 81/255, alpha: 1)
        } else {
            placeDetailsOpenStateLabel.text = "Close"
            placeDetailsOpenStateLabel.backgroundColor = .red
        }
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
