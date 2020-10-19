//
//  APIGetFamilyRequest-FamilyResponse.swift
//  Triage
//
//  Created by Tamer Bader on 10/12/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
struct APIGetFamilySuccessResponse: Codable {
    let caretakers: [APICaretakerSuccessResponse]
    let children: [APIChildSuccessResponse]
}
