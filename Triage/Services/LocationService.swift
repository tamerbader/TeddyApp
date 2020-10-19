//
//  LocationManager.swift
//  Triage
//
//  Created by Tamer Bader on 4/2/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
class LocationService: CLLocationManager  {
    static let shared = LocationService()
    
    var observers: [LocationUpdateDelegate] = []
    
    // Boolean value to track whether the service is actively tracking users location for target destination
    var serviceIsRunning = false
    
    
    override init(){}
    
    public func requestLocationAccess() {
        self.requestAlwaysAuthorization()
    }
    
    public func requestAlways() {
        self.requestAlwaysAuthorization()
    }
    
    public func isLocationServiceEnabled()-> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    public func startLocationService() {
        
        // Request Location Access Permissions
        requestLocationAccess()
        
        // Start Location Updates
        if CLLocationManager.locationServicesEnabled() {
            self.delegate = self
            self.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.allowsBackgroundLocationUpdates = true
            self.startUpdatingLocation()
        }
    }
    
    public func stopAllRegionMonitors() {
        let regions = self.monitoredRegions
        
        for region in regions {
            self.stopMonitoring(for: region)
        }
    }
    
    public func startMonitoringRegion(latitude: Double, longitude: Double, radius: Double, identifier: String) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Register the region.
            let region = CLCircularRegion(center: location,
                 radius: (radius), identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
       
            self.startMonitoring(for: region)
        }
    }
    
   /* public func registerObserver(withObserver observer: LocationUpdateDelegate){
        observers.append(observer)
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, withRadius radius: Double, identifier: String ) {
        // Make sure the devices supports region monitoring.
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Register the region.
            let region = CLCircularRegion(center: center,
                 radius: (radius*1609), identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
       
            self.startMonitoring(for: region)
            
            self.st
        }
    }
 
 */
    
    //TODO: Fix Later
    /*public func deregisterObserver(withObserver observer: LocationUpdateDelegate) {
        guard let observerIndex: Int = observers.index(where: { (item) -> Bool in
            item == observer
        })
    }*/
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations.last)
        
        APIUpdateLocationRequest(dropoffId: "\(locations.last?.coordinate.longitude ?? 0): \(locations.last?.coordinate.longitude ?? 0)", dropoffType: "Update").dispatch(onSuccess: {
            print("Success!")
        }, onFailure: {(errorResponse, error) in
            print(errorResponse)
            print(error)
        })
       /*
        //get the notification center
        let center =  UNUserNotificationCenter.current()

        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Teddy Bear"
        content.subtitle = "Location Update"
        content.body = "\(locations.last?.coordinate.latitude)"
        content.sound = UNNotificationSound.default

        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats: false)

        //create request to display
        let request = UNNotificationRequest(identifier: "teddy", content: content, trigger: trigger)

        //add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        */

       /*
        // Grabs the location coordinate from GPS
        guard let currentLocation: CLLocation = locations.last else { return }
                
        // Notifies RegionMonitor Observers to check the location
        for observer in observers {
            observer.didReceiveNewLocation(currentLocation)
        }
         */
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        print("Entered Location")
        
        APIUpdateLocationRequest(dropoffId: "\(region.identifier)", dropoffType: "ENTER").dispatch(onSuccess: {
            print("Success!")
        }, onFailure: {(errorResponse, error) in
            print(errorResponse)
            print(error)
        })
   /*
        //get the notification center
        let center =  UNUserNotificationCenter.current()

        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Teddy Bear"
        content.subtitle = "Region Enter"
        content.body = "Region ID: \(region.identifier)"
        content.sound = UNNotificationSound.default

        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats: false)

        //create request to display
        let request = UNNotificationRequest(identifier: "enter", content: content, trigger: trigger)

        //add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        
 */
        
        
       /*
        if let region = region as? CLCircularRegion {
            for observer in observers {
                observer.didRecieveNewRegionUpdate(region, motion: .ENTER)
            }
        }
        */
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        print("Exited Location")
        
        APIUpdateLocationRequest(dropoffId: "\(region.identifier)", dropoffType: "EXIT").dispatch(onSuccess: {
            print("Success!")
        }, onFailure: {(errorResponse, error) in
            print(errorResponse)
            print(error)
        })
    /*
        //get the notification center
        let center =  UNUserNotificationCenter.current()

        //create the content for the notification
        let content = UNMutableNotificationContent()
        content.title = "Teddy Bear"
        content.subtitle = "Region Exit"
        content.body = "Region ID: \(region.identifier)"
        content.sound = UNNotificationSound.default

        //notification trigger can be based on time, calendar or location
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats: false)

        //create request to display
        let request = UNNotificationRequest(identifier: "exit", content: content, trigger: trigger)

        //add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }*/
        
    }
}
