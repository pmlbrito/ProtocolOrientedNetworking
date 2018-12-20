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
        let (timestamp, hash) = self.generateRequestHash()
        return ["ts": timestamp, "apikey": self.getPublicKey(), "hash": hash]
    }
    
    fileprivate func getPublicKey() -> String { return "YOUR PUBLIC API KEY HERE" }
    fileprivate func getPrivateKey() -> String { return "YOUR PRIVATE API KEY HERE" }
    
    fileprivate func generateRequestHash() -> (String, String) {
        let timestamp = NSDate().timeIntervalSince1970.toTimestampString()
        let hash = MarvelAPIHelper.MD5("\(timestamp)\(self.getPrivateKey())\(self.getPublicKey())")
        return (timestamp, hash)
    }
}
