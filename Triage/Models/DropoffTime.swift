//
//  DropoffTime.swift
//  Triage
//
//  Created by Tamer Bader on 8/10/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

struct DropoffTime {
    var time: String
    var days: [Day]
    var date: Date
    
    
    func convertDaysToDisplayString() -> String {
        var displayText: String = ""
        for day in days {
            switch day {
            case .MONDAY:
                displayText += "Mon  "
            case .TUESDAY:
                displayText += "Tue  "
            case .WEDNESDAY:
                displayText += "Wed  "
            case .THURSDAY:
                displayText += "Thu  "
            case .FRIDAY:
                displayText += "Fri  "
            case .SATURDAY:
                displayText += "Sat  "
            case .SUNDAY:
                displayText += "Sun  "
            }
        }
        
        return displayText
    }
    
    func convertDropoffTimeToCronTime() -> [String]{
        let timeSection = date.format(withFormat: "0 mm HH")
        var cronDropoffTimes: [String] = []
        
        for day in days {
            var dayOfWeek = 0
            switch day {
            case .SUNDAY:
                dayOfWeek = 0
            case .MONDAY:
                dayOfWeek = 1
            case .TUESDAY:
                dayOfWeek = 2
            case .WEDNESDAY:
                dayOfWeek = 3
            case .THURSDAY:
                dayOfWeek = 4
            case .FRIDAY:
                dayOfWeek = 5
            case .SATURDAY:
                dayOfWeek = 6
            }
            
            let cronTime: String = "\(timeSection) * * \(dayOfWeek)"
            cronDropoffTimes.append(cronTime)
        }
        
        return cronDropoffTimes
    }
}


enum Day: Int {
    case MONDAY = 0
    case TUESDAY = 1
    case WEDNESDAY = 2
    case THURSDAY = 3
    case FRIDAY = 4
    case SATURDAY = 5
    case SUNDAY = 6
}
