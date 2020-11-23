//
//  TrackingService.swift
//  Triage
//
//  Created by Tamer Bader on 4/11/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import CoreLocation

class OldTrackingService {
    static let shared = OldTrackingService()
    var delegate: ControllerUpdateDelegate?
    
    let TARGET_LOCATION_KEY: String = "targetLocation"
    let MINIMUM_TIME_AMOUNT: Double = 0.50
    var RADIUS: Double = 0.015
    
  /*  func isServiceRunning() -> Bool {
        // Check if we have a target location set
        if (isTargetLocationSet()) {
            return true
        }
        // No location set so return false
        return false
    }
    func startService(delegate: ControllerUpdateDelegate) {
        // Set the controller delegate
        self.delegate = delegate
        
        // Start Location Manager
        //LocationService.shared.startLocationService(delegate: self)
        
        // Tell the delegate we've started GPS monitoring
        self.delegate?.didStartMonitoringLocation()
    }
    func stopService() {
        // Stop Location Updates
        LocationService.shared.stopUpdatingLocation()
    }
    
    func setTargetLocation(targetLocation:CLLocation) {
        let defaults = UserDefaults.standard
        defaults.set(location: targetLocation, forKey: TARGET_LOCATION_KEY)
    }
    
    func getTargetLocation() -> CLLocation {
        let defaults = UserDefaults.standard
        return defaults.location(forKey: TARGET_LOCATION_KEY)!
    }
    
    func setRadius(radius: Double) {
        self.RADIUS = radius
    }
    
    private func isTargetLocationSet() -> Bool {
        let defaults = UserDefaults.standard
        guard defaults.location(forKey: TARGET_LOCATION_KEY) != nil else {
            return false
        }
        return true
    }
    
    func clearTargetLocation() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: TARGET_LOCATION_KEY)
    }
    
}

extension OldTrackingService: LocationUpdateDelegate {
    func didReceiveNewLocation(_ location: CLLocation) {
        print("My New Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        
        for child in AppData.shared.currentUser.children {
            let childDropoffLocation = CLLocation(latitude: child.dropoffLocation!.latitude, longitude: child.dropoffLocation!.longitude)
            if (LocationServices.isWithinRange(source: childDropoffLocation, destination: getTargetLocation(), range: RADIUS)) {
                // Ok so we are in the zone
                
                // If the tracking timer has started just let it continue
                //if not timer has started, start the timer service
                
                if (!TimerService.shared.isTimerRunning()) {
                    // Start the timer
                    TimerService.shared.startTimer(minimumTime: MINIMUM_TIME_AMOUNT, delegate: self)
                    
                    // Tell the delegates we've entered the target location
                    delegate?.didEnterTargetZone()
                }
            }
        }
        
        
        // We left the target area, stop timer and process the time
        if (!LocationServices.isWithinRange(source: location, destination: getTargetLocation(), range: RADIUS) && TimerService.shared.isTimerRunning()) {
            print("We exited the location")
            TimerService.shared.stopTimer()
            
            if (TimerService.shared.metMinimumTimeAmount()) {
                stopService()
                TimerService.shared.clearTimer()
                delegate?.didLeaveTargetZone(true)
            } else {
                TimerService.shared.clearTimer()
                
                // Send an email right away!
                NotificationService.shared.sendNotification()
                
                delegate?.didLeaveTargetZone(false)
            }
        }
    }
    
}

extension OldTrackingService: TimerUpdateDelegate {
    
    func timerDidMeetMinimumTimer(child: Child) {
        // Stop Location Monitoring
        stopService()
        
        // Stop Timer
        TimerService.shared.stopTimer()
        
        // Tell the delegates that I've left
        delegate?.didLeaveTargetZone(true)
    }
    
*/
}

