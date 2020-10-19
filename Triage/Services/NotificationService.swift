//
//  NotificationService.swift
//  Triage
//
//  Created by Tamer Bader on 4/12/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import UIKit

class NotificationService {
    static var shared = NotificationService()
    
    
    func sendWarningNotification() {
        
    }
    
    func sendNotification(withHeading heading: String, withBody body: String) {
        let center =  UNUserNotificationCenter.current()
        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Teddy Bear"
        content.subtitle = "\(heading)"
        content.body = "\(body)"
        content.sound = UNNotificationSound.default

        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats: false)

        //create request to display
        let request = UNNotificationRequest(identifier: "\(heading)-\(body)", content: content, trigger: trigger)

        //add request to notification center
        center.add(request) { (error) in
          if error != nil {
              print("error \(String(describing: error))")
          }
        }
    }
}
