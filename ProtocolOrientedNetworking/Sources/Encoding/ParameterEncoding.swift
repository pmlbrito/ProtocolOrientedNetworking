//
//  ParameterEncoding.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 13/12/2018.
//

import Foundation

public enum ParameterEncodingFailure: Error {
    case missingURL
    case jsonEncodingFailed(error: Error)
    case propertyListEncodingFailed(error: Error)
}

public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: [String: Any]) throws
}

public enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: [String: Any]?,
                       urlParameters: [String: Any]?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                
            }
        }
        catch {
            throw error
        }
    }
}
