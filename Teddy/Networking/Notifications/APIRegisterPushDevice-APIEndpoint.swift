//
//  APIRegisterPushDevice-APIEndpoint.swift
//  Teddy
//
//  Created by Tamer Bader on 11/7/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation
extension APIRegisterPushDeviceRequest: APIEndpoint {
    func endpoint() -> String {
        return "/api/user/registerPushNotificationDevice"
    }
    
    func dispatch(
        onSuccess successHandler: @escaping (() -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _:Error) -> Void)) {
        
        APIRequest.post(request: self, onSuccess: successHandler, onError: failureHandler)
    }
    
}
