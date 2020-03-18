//
//  CharactersEndpoint.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 19/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation
import ProtocolOrientedNetworking

enum CharactersEndpointRoutes {
    case list_caracters(offset: Int, pageSize: Int)
    case download_image(imageURL: URL)
}

struct CharactersEndpoint: AuthenticatedEndpoint {
    var configuration: APIConfigurable
    var route: CharactersEndpointRoutes
    
    init(configuration: APIConfigurable, route: CharactersEndpointRoutes) {
        self.route = route
        self.configuration = configuration
    }
}

extension CharactersEndpoint {
 
    var base: String {
        switch self.route {
        case .download_image(let imageURL):
            let baseURL = imageURL.absoluteURL.absoluteString.replacingOccurrences(of: imageURL.path, with: "", options: [.caseInsensitive, .regularExpression])
            return baseURL
        default:
            return configuration.baseURL
        }
    }
    
    var path: String {
        switch self.route {
        case .list_caracters:
            return String(format: "%@%@", configuration.basePath, "characters")
        case .download_image(let imageURL):
            return imageURL.path
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self.route {
        case .list_caracters:
            return .get
        case .download_image:
            return .get
        }
    }
    
    var queryParameters: [URLQueryItem]? {
        switch self.route {
        case .list_caracters(let offset, let pageSize):
            var params = [URLQueryItem]()
            params.append(URLQueryItem(name: "limit", value: String(describing: pageSize)))
            params.append(URLQueryItem(name: "offset", value: String(describing: offset)))
            return params
        case .download_image:
            return nil
        }
    }
    
    var body: Data? {
        return nil
    }
}
