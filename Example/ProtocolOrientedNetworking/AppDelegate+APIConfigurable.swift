//
//  AppDelegate+APIConfigurable.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 13/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ProtocolOrientedNetworking

// MARK: - APIConfigurable
extension AppDelegate: APIConfigurable {
    var requestTimeout: TimeInterval { return 30 }
    
    var baseURL: String {
        return "https://gateway.marvel.com:443"
    }
    
    var basePath: String {
        return "/v1/public/"
    }
    
    var appVersion: String {
        return Bundle.versionNumber(for: Bundle.main)
    }
    
    var appQueryParams: [URLQueryItem]? {
        return nil
    }
    
    var authType: AuthenticationType? { return .querystring }
    var security: [String: String]? {
        return ["apikey": "TODO add key here"]
    }
}
