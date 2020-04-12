//
//  LocationUpdateDelegate.swift
//  Triage
//
//  Created by Tamer Bader on 4/11/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationUpdateDelegate {
    func didReceiveNewLocation(_ location: CLLocation)
}

