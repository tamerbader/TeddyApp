//
//  GPSService.swift
//  Triage
//
//  Created by Tamer Bader on 2/8/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class GPSService {
    
    init() {
    }
    
    
    func startService() {
        
        let locationManager: CLLocationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()

        /*if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }*/

        
        
    }
}
