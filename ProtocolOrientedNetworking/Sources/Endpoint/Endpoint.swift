//
//  Endpoint.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 13/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation

public protocol Endpoint {
    var configuration: APIConfigurable { get set }
    
    var base: String { get }
    var urlComponents: URLComponents { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    
    //func encode<T: Encodable>(data: T, with strategy: JSONEncoder.KeyEncodingStrategy?) -> Data?
}

public extension Endpoint {
    var base: String { return configuration.baseURL }
    
    var headers: [String: String]? {
        let deviceModel = UIDevice.current.model
        let osNumber = UIDevice.current.systemVersion
        let userAgent = String(format: "Apple|%@|%@", deviceModel, osNumber)
        return ["Content-Type": "application/json", "User-Agent": userAgent]
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = configuration.appQueryParams
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var composedURLRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: configuration.requestTimeout)
        
        self.headers?.forEach { (key, value) in
            composedURLRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        composedURLRequest.httpBody = body
        composedURLRequest.httpMethod = self.httpMethod.rawValue
        
        return composedURLRequest
    }
    
    func encode<T: Encodable>(data: T, with strategy: JSONEncoder.KeyEncodingStrategy? = nil) -> Data? {
        do {
            let jsonEncoder = JSONEncoder()
            
            if let jsonStrategy = strategy {
                jsonEncoder.keyEncodingStrategy = jsonStrategy
            }
            
            let jsonData = try jsonEncoder.encode(data)
            jsonEncoder.outputFormatting = .prettyPrinted
            NSLog("jsonData: \(String(data: jsonData, encoding: .utf8)!))")
            return jsonData
        }
        catch let error {
            NSLog("Error encoding parameters - \(error.localizedDescription)")
            return nil
        }
    }
}
