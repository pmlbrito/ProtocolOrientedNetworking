//
//  CharactersEndpoint.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 19/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import ProtocolOrientedNetworking

enum CharactersEndpoint {
    case list_caracters(offset: Int, pageSize: Int)
}

extension CharactersEndpoint: AuthenticatedEndpoint {
    
    var path: String {
        switch self {
        case .list_caracters:
            return String(format: "%@%@", APIConfiguration.shared.basePath, "characters")
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .list_caracters:
            return .get
        }
    }
    
    var queryParameters: [URLQueryItem]? {
        switch self {
        case .list_caracters(let offset, let pageSize):
            var params = [URLQueryItem]()
            params.append(URLQueryItem(name: "limit", value: String(describing: pageSize)))
            params.append(URLQueryItem(name: "offset", value: String(describing: offset)))
            return params
        }
    }
    
    var body: Data? {
        return nil
    }
}
