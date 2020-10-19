//
//  APIUpdateLocationRequest-APIEndpoint.swift
//  Triage
//
//  Created by Tamer Bader on 10/13/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

extension APIUpdateLocationRequest: APIEndpoint {
    func endpoint() -> String {
        return "/api/location/locationUpdate"
    }
    
    func dispatch(
        onSuccess successHandler: @escaping (() -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _:Error) -> Void)) {
        
        APIRequest.post(request: self, onSuccess: successHandler, onError: failureHandler)
    }
    
    
}
