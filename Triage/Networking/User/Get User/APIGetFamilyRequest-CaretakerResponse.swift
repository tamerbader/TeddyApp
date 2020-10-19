//
//  APIGetUserRequest-GuardianResponse.swift
//  Triage
//
//  Created by Tamer Bader on 7/20/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

struct APICaretakerSuccessResponse: Codable {
    let _id: String
    let fullName: String
    let emailAddress: String
    let phoneNumber: String
}
