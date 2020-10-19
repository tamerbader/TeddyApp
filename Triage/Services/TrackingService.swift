//
//  TrackingService.swift
//  Triage
//
//  Created by Tamer Bader on 8/15/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

class TrackingService {
    static let shared = TrackingService()
    var activeChildTrackers: [ChildTracker] = []
    
    public func startTracking(withChild child: Child, withDelegate delegate: ControllerUpdateDelegate) {
        for dropoff in child.dropoffs {
            // Monitor Child Dropoff Regions
            LocationService.shared.startMonitoringRegion(latitude: Double(dropoff.latitude)!, longitude: Double(dropoff.longitude)!, radius: Double(dropoff.radius)!, identifier: dropoff._id)
        }
        
        
    }
    
}
