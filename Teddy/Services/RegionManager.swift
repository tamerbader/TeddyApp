//
//  RegionMonitor.swift
//  Triage
//
//  Created by Tamer Bader on 8/17/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class RegionManager: LocationUpdateDelegate {
    var dropoffLocation: CLLocation
    var RADIUS: Double
    var childDelegate: RegionManagerDelegate
    var isInRegion: Bool = false
    var REGION_ID: String
    var child_name: String
    
    
    init(withDropoffLocation location: CLLocation, withRadius radius: Double, withRegionID regionID: String, withDelegate delegate: RegionManagerDelegate, forChild child: String) {
        // Set the dropoff location
        dropoffLocation = location
        
        // Set radius
        self.RADIUS = radius
        
        // Set the child delegate
        childDelegate = delegate
        
        // Set Region ID
        self.REGION_ID = regionID
        
        // Set the child's name
        self.child_name = child
   /*
        // Register the region manager as an observer of the location
        LocationService.shared.registerObserver(withObserver: self)
        
        // Register Background Region Monitoring
        LocationService.shared.monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), withRadius: radius, identifier: "\(child_name):\(location.coordinate.latitude):\(location.coordinate.longitude)") */
    }
    
    
    func didReceiveNewLocation(_ location: CLLocation) {
                
        // Check Location Distance From Coordinate
        let isWithinRegion: Bool = LocationServices.isWithinRange(source: location, destination: dropoffLocation, range: RADIUS)
        
        // Region Enter
        if (isWithinRegion && !isInRegion) {
            isInRegion = true
            print("Child has entered the region")
            childDelegate.didEnterRegion()
        }
        
        // Still in Region. Check for max time cutoff
        if (isWithinRegion && isInRegion) {
            print("Child is still in Region")
            childDelegate.didExceedStayTime()
        }
        
        // Region Exit
        if (!isWithinRegion && isInRegion) {
            isInRegion = false
            print("Child has left the region")
            childDelegate.didExitRegion()
        }
        
    }
    
    func didRecieveNewRegionUpdate(_ region: CLRegion, motion: RegionMotion) {
        if (region.identifier == self.REGION_ID) {
            switch motion {
            case .ENTER:
                isInRegion = true
                childDelegate.didEnterRegion()
            case .EXIT:
                isInRegion = false
                childDelegate.didExitRegion()
            }
        }
    }
    
    
}



