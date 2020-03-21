//
//  HomeVC.swift
//  Triage
//
//  Created by Tamer Bader on 2/8/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class HomeVC: UIViewController {
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var addressInputLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var targetCoordinates: CLLocation = CLLocation(latitude: 39.013811, longitude: -77.113477)
    let RADIUS: Double = 0.094697
    var isTargetDestinationSet: Bool = false
    var hasTimerStarted: Bool = false
    var timer: Timer = Timer()
    var counter: Double = 0
    var MINIMUM_TIME_SPENT_THRESHOLD: Double = 5
    
    var gpsService: GPSService = GPSService()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startGPS()

    }
    
    func setup() {
        addressField.delegate = self
        
    }
    
    
    func startGPS() {
        self.locationManager.requestAlwaysAuthorization()
               
               // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

               if CLLocationManager.locationServicesEnabled() {
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    self.locationManager.startUpdatingLocation()
        }

    }
    
    func isTargetWithinRange(latitude: Double, longitude: Double) -> Bool {
        var distanceAwayInMiles: Double = findDistanceTo(latitude: latitude, longitude: longitude)
        if (distanceAwayInMiles <= RADIUS ) {
            return true
        }
        
        return false
    }
    
    func findDistanceTo(latitude: Double, longitude: Double) -> Double {
        let targetLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        guard let currentLoc = self.currentLocation else {
            return -1
        }
        
        
        
        
        let distance: CLLocationDistance = currentLoc.distance(from: targetLocation)
        let distanceMagnitude = distance.magnitude
        let distanceInMiles = distanceMagnitude * 0.000621371
        
        print("We are \(distanceInMiles) miles away")
        
        return distanceInMiles
    }
    
    func convertAddressToCoordinate(address: String) {
        var coordinates: [Double]  = []
        
        let geoCoder = CLGeocoder()
           geoCoder.geocodeAddressString(address) { (placemarks, error) in
               guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
               else {
                   // handle no location found
                   return
               }
            
            self.targetCoordinates = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print("Target Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            self.isTargetDestinationSet = true
            
            self.performSegue(withIdentifier: "goToMapView", sender: nil)
        }
    }
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)

    }
    
    func checkTimerProgress() {
    }
    
    func validateTimeSpent() {
        print("We have left the location")
        // Stop the timer
        self.timer.invalidate()
        // Calculate the time difference
        // Compare with what they have set as the time
        
        if (self.counter < MINIMUM_TIME_SPENT_THRESHOLD * 60) {
            // Send Notification
            print("Sending email to user")
        } else {
            // Ignore
            print("Ignoring for now")
        }
        
    }
    
    @objc func UpdateTimer() {
        self.counter = self.counter + 0.1
        print("\(String(format: "%.1f", counter))")
        
    }
    
}

extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        print("Latitude: \(locValue.latitude), Longitude: \(locValue.longitude)")
        if (isTargetDestinationSet) {
            let isWithinRange: Bool = isTargetWithinRange(latitude: targetCoordinates.coordinate.latitude, longitude: targetCoordinates.coordinate.longitude)
            
            if (!isWithinRange && hasTimerStarted) {
                validateTimeSpent()
            }
            
                if (isWithinRange) {
                    if (!hasTimerStarted) {
                        hasTimerStarted = true
                        startTimer()
                        
                    }
                      print("We are at the target!")
                  } else {
                      print("We are away from the target :( ")
                  }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToMapView") {
            let destVC: MapRadiusVC = segue.destination as! MapRadiusVC
            destVC.coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(targetCoordinates.coordinate.latitude), longitude: CLLocationDegrees(targetCoordinates.coordinate.longitude))
        }
    }
}

extension HomeVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
      // TODO: handle the error.
      print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
      dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Person has clicked Next!")
        
        guard let address = addressField.text else {return false}
        convertAddressToCoordinate(address: address)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Typing \(string)")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Did end editing")
    }
}
