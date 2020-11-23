//
//  APIAddChildRequest-APIEndpoint.swift
//  Triage
//
//  Created by Tamer Bader on 7/19/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

extension APIAddChildRequest: APIEndpoint {
    func endpoint() -> String {
        return "/api/child/addChild"
    }
    
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: APIAddChildSuccessResponse) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _:Error) -> Void)) {
        
        APIRequest.post(request: self, onSuccess: successHandler, onError: failureHandler)
    }
    
}
