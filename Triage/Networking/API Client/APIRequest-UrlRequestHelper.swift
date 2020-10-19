//
//  APIRequest-UrlRequestHelper.swift
//  Triage
//
//  Created by Tamer Bader on 7/19/20.
//  Copyright © 2020 CMSC389Q. All rights reserved.
//

import Foundation

extension APIRequest {
    public static func urlRequest(from request: APIEndpoint) -> URLRequest? {
        let endpoint = request.endpoint()
        guard let endpointUrl = URL(string: "\(ApplicationProperties.serverBaseAddress)\(endpoint)") else {
            return nil
        }
        
        var endpointRequest: URLRequest = URLRequest(url: endpointUrl)
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return endpointRequest
    }
}
