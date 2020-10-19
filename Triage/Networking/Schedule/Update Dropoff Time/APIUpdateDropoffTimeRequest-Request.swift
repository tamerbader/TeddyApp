//
//  APIUpdateDropoffTimeRequest-Request.swift
//  Triage
//
//  Created by Tamer Bader on 8/12/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

struct APIUpdateDropoffTimeRequest: Codable {
    let times: [String]
    let childId: String
}
