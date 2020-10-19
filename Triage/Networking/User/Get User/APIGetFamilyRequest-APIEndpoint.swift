//
//  APIGetUserRequest-APIEndpoint.swift
//  Triage
//
//  Created by Tamer Bader on 7/19/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

struct APIGetFamilyRequest: APIEndpoint {
    func endpoint() -> String {
        return "/api/user/getFamily"
    }
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: APIGetFamilySuccessResponse) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _:Error) -> Void)) {
        
        APIRequest.get(request: self, onSuccess: successHandler, onError: failureHandler)
    }
    
    
    
}
