//
//  Date+Time-Helpers.swift
//  Triage
//
//  Created by Tamer Bader on 8/10/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

extension Date {
    func apiFormat() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "mm HH"
        
        let formattedDate: String = formatter.string(from: self)
        print(formattedDate)
        
        return formattedDate
    }
    
    func format(withFormat format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    func displayTimeFormat() -> String {
        let calendar: Calendar = Calendar.current
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "mm"
        
        let hour: Int = calendar.component(.hour, from: self)
        
        if (hour > 12) {
            return "\(hour - 12):\(formatter.string(from: self)) P.M"
        } else if (hour == 12) {
            return "\(hour):\(formatter.string(from: self)) P.M"
        } else {
            return "\(hour):\(formatter.string(from: self)) A.M"
        }
    }
    
    public static func getDateDiff(start: Date, end: Date) -> Int {
        let difference = Calendar.current.dateComponents([.second], from: start, to: end)
        guard let duration = difference.second else {return 0}
        return duration
    }
}
