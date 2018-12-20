//
//  AuthenticatedEndpoint.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 13/12/2018.
//

import Foundation

public protocol AuthenticatedEndpoint: Endpoint {
    var authType: AuthenticationType? { get }
    var security: [String: String]? { get }
    var queryParameters: [URLQueryItem]? { get }
}

public extension AuthenticatedEndpoint {
    public var authType: AuthenticationType? { return APIConfiguration.shared.authType }
    public var security: [String: String]? { return APIConfiguration.shared.security }
    
    public var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        var queryParams = APIConfiguration.shared.appQueryParams != nil ? APIConfiguration.shared.appQueryParams : [URLQueryItem]()
        if !self.security.isNilOrEmpty {
            if let auth = self.authType {
                switch auth {
                case .querystring:
                    self.security?.forEach { (arg) in
                        let (key, value) = arg
                        queryParams?.append(URLQueryItem(name: key, value: value))
                    }
                    break
                default:
                    break
                }
            }
        }
        
        if let additionQueryParameters = self.queryParameters {
            queryParams?.append(contentsOf: additionQueryParameters)
        }
        
        components.queryItems = queryParams
        return components
    }
    
    var request: URLRequest {
        
        let url = urlComponents.url!
        NSLog("URL: \(url)")
        var composedURLRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: APIConfiguration.shared.requestTimeout)
        
        self.headers?.forEach { (key, value) in
            composedURLRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        composedURLRequest.httpBody = self.body
        
        composedURLRequest.httpMethod = self.httpMethod.rawValue
        if !self.security.isNilOrEmpty {
            if let auth = self.authType {
                switch auth {
                case .headers:
                    self.security?.forEach { (arg) in
                        let (key, value) = arg
                        composedURLRequest.setValue(value, forHTTPHeaderField: key)
                    }
                    break
                default:
                    break
                }
            }
        }
        return composedURLRequest
    }
}
