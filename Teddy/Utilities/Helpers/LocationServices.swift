//
//  LocationServices.swift
//  Triage
//
//  Created by Tamer Bader on 3/1/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import CoreLocation

class LocationServices {
    
    static let METERS_TO_MILES_FACTOR: Double = 0.000621371
    
    /* Function to calculate the distance in miles between two points */
    
    static func isWithinRange(source: CLLocation, destination: CLLocation, range: Double) -> Bool {
        let distance: Double = findDistanceTo(source: source, destination: destination)
        print("Phone is \(distance) miles away")
        if (distance <= range) {
            return true
        }
        return false
    }
    
    static func findDistanceTo(source: CLLocation, destination: CLLocation) -> Double {
        // Get CLLocation Distance from source to destination
        let distance: CLLocationDistance = source.distance(from: destination)
        // Find the magnitide in order to eliminate negatives
        let distanceMagnitude = distance.magnitude
        // Convert to Miles
        let distanceInMiles = distanceMagnitude * METERS_TO_MILES_FACTOR
        
        // Return distance in miles
        return distanceInMiles
    }
    
    /* Method to convert a string input address to GPS Coordinate in form of CLLocation */
    static func convertAddressToCoordinate(address: String, completionHandler: @escaping (CLLocation?, Error?) -> Void) {
        let geoCoder = CLGeocoder()
           geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if (error == nil) {
                guard
                 let placemarks = placemarks,
                 let location = placemarks.first?.location
                else {
                    // handle no location found
                    completionHandler(nil, error)
                    return
                }
                completionHandler(location, nil)
                
            }
               
            
        }
    }
    
    
    
    
}
