//
//  APIRegisterRequest-APIEndpoint.swift
//  Triage
//
//  Created by Tamer Bader on 7/19/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

extension APIRegisterRequest: APIEndpoint {
    func endpoint() -> String {
        return "/api/auth/register"
    }
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: APIRegisterSuccessResponse) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _:Error) -> Void)) {
        
        APIRequest.post(request: self, onSuccess: successHandler, onError: failureHandler)
    }
}
