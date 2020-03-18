//
//  APIConfiguration.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 13/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation

public class APIConfiguration: APIConfigurable {
    public var requestTimeout: TimeInterval { return self._requestTimeout ?? 10.0}
    public var baseURL: String { return self._baseURL ?? "" }
    public var basePath: String { return self._basePath ?? "" }
    public var appVersion: String { return self._appVersion ?? Bundle().object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""}
    public var appQueryParams: [URLQueryItem]? { return self._appQueryParams }
    public var authType: AuthenticationType? { return self._authType }
    public var security: [String : String]? { return self._security }
    
    private var _requestTimeout: TimeInterval?
    private var _baseURL: String?
    private var _basePath: String?
    private var _appVersion: String?
    private var _appQueryParams: [URLQueryItem]?
    private var _authType: AuthenticationType?
    private var _security: [String : String]?
    
    public init(baseUrl: String?, basePath: String?, requestTimeout: TimeInterval?, appVersion: String?, appQueryParams: [URLQueryItem]?, authType: AuthenticationType?, security: [String : String]?) {
        self._baseURL = baseUrl
        self._basePath = basePath
        self._requestTimeout = requestTimeout
        self._appVersion = appVersion
        self._appQueryParams = appQueryParams
        self._authType = authType
        self._security = security
    }
}
