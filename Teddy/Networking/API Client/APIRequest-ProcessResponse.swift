//
//  APIRequest-ProcessResponse.swift
//  Triage
//
//  Created by Tamer Bader on 7/19/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

extension APIRequest {
    public static func processResponse<T: Codable, E: Codable>(
        _ dataOrNil: Data?,
        _ urlResponseOrNil: URLResponse?,
        _ errorOrNil: Error?,
        onSuccess: ((_:T) -> Void),
        onError: ((_:E?, _:Error) -> Void)) {
        
        if let data = dataOrNil {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                onSuccess(decodedResponse)
            } catch {
                let originalError = error
                
                do {
                    let errorResponse = try JSONDecoder().decode(E.self, from: data)
                    onError(errorResponse, APIError.errorResponseDetected)
                } catch {
                    onError(nil, originalError)
                }
            }
        } else {
            onError(nil, errorOrNil ?? APIError.noData)
        }
    }
    
    public static func processRespone<E: Codable>(
        _ dataOrNil: Data?,
        _ urlResponseOrNil: URLResponse?,
        _ errorOrNil: Error?,
        onSuccess: (() -> Void),
        onError: ((_:E?, _:Error) -> Void)) {
        if let urlResponse = urlResponseOrNil as? HTTPURLResponse {
            if (urlResponse.statusCode == 200) {
                onSuccess()
            } else {
                onError(nil, APIError.errorResponseDetected)
            }
        } else {
            onError(nil, APIError.noData)
        }
    }
}
