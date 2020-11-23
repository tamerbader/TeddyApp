//
//  APILoginRequest-Request.swift
//  Triage
//
//  Created by Tamer Bader on 8/31/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
struct APILoginRequest: Codable {
    let emailAddress: String
    let password: String
}
