//
//  APIGetFamilyReqest-DropoffResponse.swift
//  Triage
//
//  Created by Tamer Bader on 10/12/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

struct APIDropoffSuccessResponse: Codable {
    let _id: String
    let latitude: String
    let longitude: String
    let radius: String
    let times: [String]
    let nickname: String
}
