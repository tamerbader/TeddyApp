//
//  LocationManager.swift
//  Triage
//
//  Created by Tamer Bader on 4/2/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import CoreLocation
class LocationService: CLLocationManager  {
    static let shared = LocationService()
    
    var trackingDelegate: LocationUpdateDelegate?
    
    // Boolean value to track whether the service is actively tracking users location for target destination
    var serviceIsRunning = false
    
    
    override init(){}
    
    private func requestLocationAccess() {
        self.requestAlwaysAuthorization()
        self.requestWhenInUseAuthorization()
    }
    
    func startLocationService(delegate: TrackingService) {
        // Set Tracking Service as Delegate
        self.trackingDelegate = delegate
        
        // Request Location Access Permissions
        requestLocationAccess()
        
        // Start Location Updates
        if CLLocationManager.locationServicesEnabled() {
            self.delegate = self
            self.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.startUpdatingLocation()
            self.allowsBackgroundLocationUpdates = true
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let currentLocation: CLLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        trackingDelegate?.didReceiveNewLocation(currentLocation)
    }
}

extension LocationService {
    func processLocationUpdate(newLocation: CLLocation) {
        // First Check If Target Location Is Set
        let defaults = UserDefaults.standard
        let targetLocation: CLLocation? = defaults.location(forKey: "targetLocation") as? CLLocation ?? nil
        if (targetLocation != nil && !serviceIsRunning) {
            print("Yo target is set. Start that service bitch up")
            self.serviceIsRunning = true
        }
    }
}
