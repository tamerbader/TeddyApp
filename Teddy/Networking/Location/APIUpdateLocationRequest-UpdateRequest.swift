//
//  APIUpdateLocationRequest-UpdateRequest.swift
//  Triage
//
//  Created by Tamer Bader on 10/13/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

struct APIUpdateLocationRequest: Codable {
    let dropoffId: String
    let dropoffType: String
}
