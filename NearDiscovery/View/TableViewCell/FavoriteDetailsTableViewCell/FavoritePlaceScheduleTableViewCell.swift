//
//  FavoritePlaceScheduleTableViewCell.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 20/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import UIKit

class FavoritePlaceScheduleTableViewCell: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var scheduleTextView: UITextView!
    
    //MARK: - Method
    func scheduleOpenStateCellConfigure(favoritePlaceDetails: Favorite?) {
        scheduleTextView.text = convertDetailedFavoritePlaceSchedule(schedule: favoritePlaceDetails?.schedule ?? "No Schedule Available")
    }
    
    //MARK: - Helper's method
    private func convertDetailedFavoritePlaceSchedule(schedule: String) -> String {
        var description = ""
        let detailedFavoritePlaceScheduleArray = schedule.components(separatedBy: ", ")
        for weekdayText in detailedFavoritePlaceScheduleArray {
            description += weekdayText + "\n"
        }
        return description
    }
}
