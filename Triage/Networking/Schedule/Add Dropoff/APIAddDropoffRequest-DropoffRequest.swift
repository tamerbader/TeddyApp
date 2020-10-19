//
//  APIAddDropoffRequest-DropoffRequest.swift
//  Triage
//
//  Created by Tamer Bader on 10/13/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import UIKit

struct APIAddDropoffRequest: Codable {
    let childId: String
    let latitude: String
    let longitude: String
    let radius: String
    let times: [String]
}
