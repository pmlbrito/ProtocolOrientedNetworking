//
//  String+Optional.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 19/12/2018.
//

import Foundation

protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {
    var isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
    
    var isNilOrEmptyTrimmed: Bool {
        return ((self as? String) ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
