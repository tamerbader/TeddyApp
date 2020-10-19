//
//  APIRequest-Base.swift
//  Triage
//
//  Created by Tamer Bader on 7/19/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

protocol APIEndpoint {
    func endpoint() -> String
}

class APIRequest {
    struct ErrorResponse: Codable {
        let message: String
    }
    
    enum APIError: Error {
        case invalidEndpoint
        case errorResponseDetected
        case noData
    }
}
