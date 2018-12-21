//
//  APIConfigurable.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 13/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation

public enum AuthenticationType {
    case querystring
    case headers
}

public protocol APIConfigurable: class {
    var requestTimeout: TimeInterval { get }
    var baseURL: String { get }
    var basePath: String { get }
    var appVersion: String { get }
    var appQueryParams: [URLQueryItem]? { get }
    
    //authentication
    var authType: AuthenticationType? { get }
    var security: [String: String]? { get }
    
    // TODO: Add more params if you need
}
