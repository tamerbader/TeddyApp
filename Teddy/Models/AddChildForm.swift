//
//  AddChildForm.swift
//  Triage
//
//  Created by Tamer Bader on 10/12/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
import CoreLocation

class AddChildForm {
    var fullName: String?
    var dropoffs: [DropoffBuilder] = []
}

class DropoffBuilder {
    var name: String?
    var nickname: String?
    var location: CLLocationCoordinate2D?
    var radius: Double?
    var times: [String] = []
}
