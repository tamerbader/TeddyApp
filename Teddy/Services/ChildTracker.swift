//
//  ChildTracker.swift
//  Triage
//
//  Created by Tamer Bader on 8/17/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import CoreLocation

class ChildTracker {
 /*
    var child: Child
    var regionManagers: [RegionManager] = []
    var regionEnteredTime: Date?
    var delegate: ControllerUpdateDelegate
    var MINIMUM_REGION_DURATION: Int = 60
    var MAXIMUM_REGION_DURATION: Int = 120
    var REGION_ID: String
    var cutoffEnabled: Bool = true
    
    init(withChild child: Child, withRegionID regionID: String, withDelegate delegate: ControllerUpdateDelegate) {
        self.child = child
        self.delegate = delegate
        self.REGION_ID = regionID
        
        // Grab the dropoff location
        guard let dropoffCoordinates: CLLocationCoordinate2D = child.dropoffLocation else {return}
        let dropoffLocation: CLLocation = CLLocation(latitude: dropoffCoordinates.latitude, longitude: dropoffCoordinates.longitude)
                
        // Start Region Manager
        print("Now Tracking \(child.fullName)")
        delegate.didStartTracking(withChild: child)
        addRegionManager(withLocation: dropoffLocation)
        

        
    }
    
    public func addRegionManager(withLocation location: CLLocation) {
        print("Child Radius is: \(child.dropoffRadius!)")
        guard let radius: Double = child.dropoffRadius else {return}
        var rm = RegionManager(withDropoffLocation: location, withRadius: radius,withRegionID: REGION_ID, withDelegate: self, forChild: child.fullName!)
        regionManagers.append(rm)
    }
    
    func didEnterRegion() {
        // Set the time of region entered
        self.regionEnteredTime = Date()
        NotificationService.shared.sendNotification(withHeading: "Location Update", withBody: "\(child.fullName!) has entered the region.")
        delegate.didEnterRegion(withChild: child)
    }
    
    func didExitRegion() {
        NotificationService.shared.sendNotification(withHeading: "Location Update", withBody: "\(child.fullName!) has exited the region.")

        delegate.didExitRegion(withChild: child)
        let currentTime: Date = Date()
        
        let durationOfStay: Int = Date.getDateDiff(start: regionEnteredTime!, end: currentTime)
        
        if (durationOfStay > MINIMUM_REGION_DURATION) {
            cutoffEnabled = true
            delegate.didDropoff(withChild: child)
            APIConfirmDropoffRequest(childId: child._id!).dispatch(onSuccess: {
                print("\(self.child.fullName!) has been dropped off!")
            }, onFailure: { (err, error) in
                print("Child couldn't communicate with server to dropoff.")
            })
        }
    }
    
    func didExceedStayTime() {
        let currentTime: Date = Date()
        let durationOfStay: Int = Date.getDateDiff(start: regionEnteredTime!, end: currentTime)
        
        if (durationOfStay > MAXIMUM_REGION_DURATION && cutoffEnabled) {
            self.cutoffEnabled = false
            self.delegate.didDropoff(withChild: self.child)
            APIConfirmDropoffRequest(childId: child._id!).dispatch(onSuccess: {
                print("\(self.child.fullName!) has been dropped off!")
            }, onFailure: { (err, error) in
                print("Child couldn't communicate with server to dropoff.")
            })
        }

    }
 */
}
