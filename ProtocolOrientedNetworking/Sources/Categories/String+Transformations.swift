//
//  String+Transformations.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 13/12/2018.
//

import Foundation

extension String {
    func convertStringToDictionary() throws -> [String: AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            }
            catch let error as PONetworkingError {
                NSLog("Error parsing translations from string: \(error)")
                throw PONetworkingError.jsonParsingFailure
            }
        }
        return nil
    }
    
    static func convertDataToString(data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }
    
    mutating func insert(string: String, at index: Int) {
        self.insert(contentsOf: string, at: self.index(self.startIndex, offsetBy: index))
    }
}
