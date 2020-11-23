//
//  APIRegisterRequest-Request.swift
//  Triage
//
//  Created by Tamer Bader on 7/19/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

struct APIRegisterRequest: Codable {
    let fullName: String
    let emailAddress: String
    let phoneNumber: String
    let password: String
    let familyId: String?
}
