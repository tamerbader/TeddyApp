//
//  APILoginRequest-Response.swift
//  Triage
//
//  Created by Tamer Bader on 8/31/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
struct APILoginSuccessResponse: Codable {
    let user_id: String
    let jwt: String
}
