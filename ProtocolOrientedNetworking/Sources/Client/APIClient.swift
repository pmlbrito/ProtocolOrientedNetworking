//
//  APIClient.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 19/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation

public protocol APIClient {
    var session: URLSession { get }
    func execute<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, jsonStrategy: JSONDecoder.KeyDecodingStrategy?, completion: @escaping (Result<T, PONetworkingError>) -> Void)
}

public extension APIClient {
    var session: URLSession { return URLSession.shared }
    
    typealias JSONTaskCompletionHandler = (Decodable?, PONetworkingError?) -> Void
    typealias ImageTaskCompletionHandler = (Data?, PONetworkingError?) -> Void
    
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, jsonStrategy: JSONDecoder.KeyDecodingStrategy? = nil, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            NSLog(httpResponse.description)
            if let responseData = data {
                if let jsonString = String(data: responseData, encoding: String.Encoding.utf8) {
                    NSLog("Response Data:" + jsonString)
                }
            }
            
            if httpResponse.statusCode == 200 {
                // Check for header content type html. If exists throw an arror - some servers redirect error responses to requests to generic handling to avoid exposing too much about infrastructure and error policies
                if let headers = httpResponse.allHeaderFields as? [String: String] {
                    let foundHtml = headers.contains(where: { (key, value) -> Bool in
                        //headers are not case sensitive and may containg specific encoding info in value
                        return key.lowercased() == "content-type" && value.lowercased().contains("html")
                    })
                    if foundHtml {
                        completion(nil, .responseUnsuccessful)
                        return
                    }
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        if let strategy = jsonStrategy {
                            decoder.keyDecodingStrategy = strategy
                        }
                        
                        let genericModel = try decoder.decode(decodingType, from: data)
                        completion(genericModel, nil)
                    }
                    catch {
                        completion(nil, .jsonConversionFailure)
                    }
                }
                else {
                    completion(nil, .invalidData)
                }
            }
                //this concrete implementation had in mind that server would have diferente error codes for exposing business logic and for such... (yuc it was, but it was the way it was...)
            else if httpResponse.statusCode == 403 || httpResponse.statusCode == 409 || httpResponse.statusCode == 500 {
                completion(nil, .businessLogicError(response: data))
            }
            else if httpResponse.statusCode == 401 {
                completion(nil, .unauthorizedError(response: data))
            }
            else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    private func decodingTaskForImageDownload(with request: URLRequest, completionHandler completion: @escaping ImageTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    completion(data, nil)
                }
                else {
                    completion(nil, .invalidData)
                }
            }
            else if httpResponse.statusCode == 403 || httpResponse.statusCode == 409 || httpResponse.statusCode == 500 {
                completion(nil, .businessLogicError(response: data))
            }
            else if httpResponse.statusCode == 401 {
                completion(nil, .unauthorizedError(response: data))
            }
            else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    private func decodingTaskForImageUpload(with request: URLRequest, completionHandler completion: @escaping (PONetworkingError?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.requestFailed)
                return
            }
            
            //TODO: check for specific error code for token expired and call a retry action on the request
            // when mdw decides the code and logic to implement
            
            if httpResponse.statusCode == 200 {
                // Check for header content type html. If exists throw an arror
                if let headars = httpResponse.allHeaderFields as? [String: String], let contentType = headars["Content-Type"], contentType == "text/html" {
                    completion(.responseUnsuccessful)
                    return
                }
                
                if data != nil {
                    completion(nil)
                }
                else {
                    completion(.invalidData)
                }
            }
            else if httpResponse.statusCode == 409 || httpResponse.statusCode == 500 {
                completion(.businessLogicError(response: data))
            }
            else if httpResponse.statusCode == 401 {
                completion(.unauthorizedError(response: data))
            }
            else {
                completion(.responseUnsuccessful)
            }
        }
        return task
    }
    
    func execute<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, jsonStrategy: JSONDecoder.KeyDecodingStrategy? = nil, completion: @escaping (Result<T, PONetworkingError>) -> Void) {
        
        let task = self.decodingTask(with: request, decodingType: T.self, jsonStrategy: jsonStrategy) { (json, error) in
            // MARK: change to main queue
            DispatchQueue.main.async {
                
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    }
                    else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                }
                else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
    
    func executeForImageDownload(with request: URLRequest, completion: @escaping(Result<UIImage?, PONetworkingError>) -> Void) {
        let task = decodingTaskForImageDownload(with: request) { (data, error) in
            // MARK: change to main queue
            DispatchQueue.main.async {
                guard let imageData = data else {
                    if let error = error {
                        completion(Result.failure(error))
                    }
                    else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                if let image = UIImage(data: imageData) {
                    completion(.success(image))
                }
                else {
                    completion(Result.failure(.invalidData))
                }
            }
        }
        task.resume()
    }
    
    func executeForImageUpload(with request: URLRequest, completion: @escaping(Result<Bool, PONetworkingError>) -> Void) {
        let task = decodingTaskForImageUpload(with: request) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(Result.failure(error))
                }
                else {
                    completion(Result.success(true))
                }
            }
        }
        task.resume()
    }
    
   
}
