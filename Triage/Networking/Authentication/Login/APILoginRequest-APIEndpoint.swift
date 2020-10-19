//
//  APILoginRequest-APIEndpoint.swift
//  Triage
//
//  Created by Tamer Bader on 8/31/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
extension APILoginRequest: APIEndpoint {
    func endpoint() -> String {
        "/api/auth/login"
    }
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: APILoginSuccessResponse) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _:Error) -> Void)) {
        
        APIRequest.post(request: self, onSuccess: successHandler, onError: failureHandler)
    }
}
