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
    
    public func isAlwaysAuthorized() -> Bool {
        let authStatus = LocationService.authorizationStatus()
        if (authStatus != .authorizedAlways) {
            return false
        } else {
            return true
        }
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
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = manager.location?.coordinate
        AppData.shared.currentLocation = currentLocation
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        print("Entered Location")
        
        APIUpdateLocationRequest(dropoffId: "\(region.identifier)", dropoffType: "ENTER").dispatch(onSuccess: {
            print("Success!")
        }, onFailure: {(errorResponse, error) in
            print(errorResponse ?? "error response")
            print(error)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        print("Exited Location")
        
        APIUpdateLocationRequest(dropoffId: "\(region.identifier)", dropoffType: "EXIT").dispatch(onSuccess: {
            print("Success!")
        }, onFailure: {(errorResponse, error) in
            print(errorResponse ?? "error response")
            print(error)
        })
        
    }
}
