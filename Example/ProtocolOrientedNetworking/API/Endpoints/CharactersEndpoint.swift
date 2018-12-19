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
    case list_caracters
}

extension CharactersEndpoint: Endpoint {
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
    
    var body: Data? {
        return nil
    }
    
    
}
