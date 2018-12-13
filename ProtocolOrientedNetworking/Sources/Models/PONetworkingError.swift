//
//  PONetworkingError.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 13/12/2018.
//

import Foundation

public enum PONetworkingError: Error {

case invalidURL(url: URLConvertible)
case parameterEncodingFailed(reason: ParameterEncodingFailure)

case NetworkError(error: Error)
case UnexpectedError
case requestFailed
case jsonConversionFailure
case invalidData
case responseUnsuccessful
case jsonParsingFailure
case genericError(description: String?)

//Business Logic Error
case businessLogicError(response: Data?)

// Session Token expired
case unauthorizedError(response: Data?)

public var localizedDescription: String {
    switch self {
    case .invalidURL(let url):
        NSLog("invalid URL \(url)")
        return "PONetworkingError.InvalidURL"
    case .parameterEncodingFailed(let reason):
        NSLog("Request Parameter Encoding Failed \(reason)")
        return "PONetworkingError.RequestParameterEncodingFailed"
    case .NetworkError(let error):
        NSLog("Network Error \(error)")
        return "PONetworkingError.NetworkError"
    case .UnexpectedError:
        NSLog("Unexpected Error")
        return "PONetworkingError.UnexpctedError"
    case .requestFailed:
        NSLog("Request Failed")
        return "PONetworkingError.RequestFailed"
    case .invalidData:
        NSLog("Invalid Data")
        return "PONetworkingError.InvalidData"
    case .responseUnsuccessful:
        NSLog("Response Unssuccessful")
        return "PONetworkingError.ResponseUnsuccessful"
    case .jsonParsingFailure:
        NSLog("JSON Parsing Failure")
        return "PONetworkingError.JSONParsingFailure"
    case .jsonConversionFailure:
        NSLog("JSON Conversion Failure")
        return "PONetworkingError.JSONConversionFailure"
    case .businessLogicError(let response), .unauthorizedError(let response): do {
        //this is where you parse the response content for business specific error messages sent form the webservices in the response body - let's say the response is something like: {errorcode: 11111, message: "This is a parsable business logic error"}
        if let responseData = response, let jsonString = String.convertDataToString(data: responseData) {
            NSLog("Response Data: \(String(describing: jsonString))")
            
            do {
                let errorContent = try jsonString.convertStringToDictionary()
                if let message = errorContent?["message"] as? String {
                    return message
                }
                return "PONetworkingError.GenericError"
            }
            catch let error as NSError {
                NSLog(error.localizedDescription)
                return "PONetworkingError.GenericError"
            }
        }
        return "PONetworkingError.GenericError"
        }
    case .genericError(let description):
        return "PONetworkingError.GenericError" + " : " + (description ?? "")
    }
}

public var code: String {
    switch self {
    case .invalidURL: return "-10006"
    case .parameterEncodingFailed: return "-10007"
    case .NetworkError(let error): return "\((error as NSError).code)"
    case .UnexpectedError: return "-10008"
    case .genericError: return "-272727"
    case .requestFailed: return "-10001"
    case .invalidData: return "-10002"
    case .responseUnsuccessful: return "-10003"
    case .jsonParsingFailure: return "-10004"
    case .jsonConversionFailure: return "-10005"
    case .businessLogicError(let response), .unauthorizedError(let response): do {
        //this is where you parse the response content for business specific error messages sent form the webservices in the response body - let's say the response is something like: {errorcode: 11111, message: "This is a parsable business logic error"}
        if let responseData = response, let jsonString = String.convertDataToString(data: responseData) {
            NSLog("Response Data: \(String(describing: jsonString))")
            
            do {
                let errorContent = try jsonString.convertStringToDictionary()
                let jsonCode = errorContent?["errorcode"]
                
                switch jsonCode {
                case let asInt as Int: return String(asInt)
                case let asString as String: return asString
                default: return "-10010"
                }
            }
            catch let error as NSError {
                NSLog(error.localizedDescription)
                return "-10010"
            }
        }
        return "-10010"
        }
    }
}

public var domain: String {
    switch self {
    case .invalidURL(let url): return "Communication: \(url)"
    case .parameterEncodingFailed(let reason): return "Request: \(reason)"
    case .NetworkError(let error): return "Communication: \((error as NSError).domain)"
    case .UnexpectedError: return "Generic"
    case .genericError: return "Generic"
    case .requestFailed: return "Communication"
    case .invalidData: return "Response"
    case .responseUnsuccessful: return "Response"
    case .jsonParsingFailure: return "JSONParsing"
    case .jsonConversionFailure: return "JSONConversion"
    case .businessLogicError: return "BusinessMDWLogic"
    case .unauthorizedError: return "InvalidAuthentication"
    }
}

public init(withGenericDescription: String?) {
    self = .genericError(description: withGenericDescription)
}
}
