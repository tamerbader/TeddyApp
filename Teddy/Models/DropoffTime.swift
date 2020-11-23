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
        let sortedDays = days.sorted(by: {$0.rawValue < $1.rawValue})
        for day in sortedDays {
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
    
    static func createFromCronTimes(cronTimes: [String]) -> [DropoffTime] {
        
        var times: [String: DropoffTime] = [:]
        
        
        for cronTime in cronTimes {
            // Decode cron time format: sec min hour * * day
            let cronSections = cronTime.components(separatedBy: " ")
            
            // Extract data we need
            let cronMinutes = cronSections[1]
            let cronHour = cronSections[2]
            let cronDay = cronSections[5]
            
            // Convert time to date object
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.date(from: "\(cronHour):\(cronMinutes)")
            
            // Get Day Object
            var dayNumber: Int = Int(cronDay)!
            if (dayNumber == 0) {
                dayNumber = 6
            } else {
                dayNumber -= 1
            }
            let day = Day(rawValue: dayNumber)!
            
            // Time Formatter
            let time = date?.apiFormat()
            
            
            if (times.keys.contains("\(cronHour):\(cronMinutes)")) {
                var dropoffTime: DropoffTime = times["\(cronHour):\(cronMinutes)"]!
                dropoffTime.days.append(day)
                times["\(cronHour):\(cronMinutes)"] = dropoffTime
            } else {
                var dropoffTime: DropoffTime = DropoffTime(time: time!, days: [], date: date!)
                dropoffTime.days.append(day)
                times["\(cronHour):\(cronMinutes)"] = dropoffTime
            }
        }
        
        var dropoffTimes: [DropoffTime] = []
        
        for key in times.keys {
            dropoffTimes.append(times[key]!)
        }
        
        return dropoffTimes
        
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
