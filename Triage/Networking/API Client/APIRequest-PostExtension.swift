//
//  APIRequest-PostExtension.swift
//  Triage
//
//  Created by Tamer Bader on 7/19/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

extension APIRequest {
    public static func post<R:Codable & APIEndpoint, T: Codable, E: Codable>(
        request: R,
        onSuccess: @escaping ((_:T) -> Void),
        onError: @escaping ((_:E?, _: Error) -> Void)) {
        
        guard var endpointRequest = self.urlRequest(from: request) else {
            onError(nil, APIError.invalidEndpoint)
            return
        }
        
        endpointRequest.httpMethod = "POST"
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if (UserDefaults.standard.string(forKey: "jwt") != nil) {
            endpointRequest.addValue("\(UserDefaults.standard.string(forKey: "jwt")!)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            endpointRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            onError(nil, error)
            return
        }
        
        URLSession.shared.dataTask(
            with: endpointRequest,
            completionHandler: { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
                }
            }).resume()
    }
    
    public static func post<R: Codable & APIEndpoint, E: Codable>(
        request: R,
        onSuccess: @escaping (()-> Void),
        onError: @escaping ((_:E?, _: Error) -> Void)) {
        
        guard var endpointRequest = self.urlRequest(from: request) else {
            onError(nil, APIError.invalidEndpoint)
            return
        }
        
        endpointRequest.httpMethod = "POST"
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if (UserDefaults.standard.string(forKey: "jwt") != nil) {
            endpointRequest.addValue("\(UserDefaults.standard.string(forKey: "jwt")!)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            endpointRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            onError(nil, error)
            return
        }
        
        URLSession.shared.dataTask(
            with: endpointRequest,
            completionHandler: { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    self.processRespone(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
                }
            }).resume()
        
    }
    
}
