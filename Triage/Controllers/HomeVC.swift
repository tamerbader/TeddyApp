//
//  HomeVC.swift
//  Triage
//
//  Created by Tamer Bader on 2/8/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController {
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var addressInputLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if (TrackingService.shared.isServiceRunning()) {
            TrackingService.shared.startService(delegate: self)
            addressField.isHidden = true
            addressInputLabel.isHidden = true
        } else {
            addressField.isHidden = false
            addressInputLabel.isHidden = false
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToMapView") {
            let destVC: MapRadiusVC = segue.destination as! MapRadiusVC
            destVC.coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(TrackingService.shared.getTargetLocation().coordinate.latitude), longitude: CLLocationDegrees(TrackingService.shared.getTargetLocation().coordinate.longitude))
        }
    }
    
    func setup() {
        addressField.delegate = self
        
    }
    func setTarget(address: String) {
        
        // Convert the address to a coordinate
        LocationServices.convertAddressToCoordinate(address: address, completionHandler: { (location, error) in
            if (error == nil) {
                guard let targetLocation = location else {return}
                
                // Save the new Target Location To User Defaults
                TrackingService.shared.setTargetLocation(targetLocation: targetLocation)
                
                // Start Service
                TrackingService.shared.startService(delegate: self)
            }
            
        })
    }
    
    


    
}

extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Grab the address text from Text Field
        guard let address = addressField.text else {return false}
        
        // Set the address as target location
        setTarget(address: address)
        
        // Let the text field return true
        return true
    }
}

extension HomeVC: ControllerUpdateDelegate {
    func didStartMonitoringLocation() {
        print("We've started monitoring your location")
    }
    
    func didEnterTargetZone() {
        print("You've entered the target location")

    }
    
    func didLeaveTargetZone(_ didSpendEnougTime: Bool) {
        if (!didSpendEnougTime) {
            print("You left the area but didn't spend enough time")
        } else {
            print("You have spent enough time in the area. Good job!")
        }
    }
    
    
}

protocol ControllerUpdateDelegate {
    func didStartMonitoringLocation()
    func didEnterTargetZone()
    func didLeaveTargetZone(_ didSpendEnougTime: Bool)
}
