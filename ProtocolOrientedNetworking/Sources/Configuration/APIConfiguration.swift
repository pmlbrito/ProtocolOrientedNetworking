//
//  APIConfiguration.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 13/12/2018.
//

import Foundation

public class APIConfiguration: APIConfigurable {
    public var requestTimeout: TimeInterval { return apiConfigurableDelegate.requestTimeout }
    public var baseURL: String { return apiConfigurableDelegate.baseURL }
    public var basePath: String { return apiConfigurableDelegate.basePath }
    public var appVersion: String { return apiConfigurableDelegate.appVersion }
    public var appQueryParams: [URLQueryItem]? { return apiConfigurableDelegate.appQueryParams }
    public var authType: AuthenticationType? { return apiConfigurableDelegate.authType }
    public var security: [String : String]? { return apiConfigurableDelegate.security }
    
    private weak var apiConfigurableDelegate: APIConfigurable!
    
    public static let shared = APIConfiguration()
    
    private init() {
        guard let apiDelegate = UIApplication.shared.delegate as? APIConfigurable else {
            assertionFailure("Error: App delegate should implement APIConfigurable protocol")
            return
        }
        self.apiConfigurableDelegate = apiDelegate
    }
}
