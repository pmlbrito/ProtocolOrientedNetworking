//
//  Collection+Optional.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 19/12/2018.
//

import Foundation

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
        case .some(let nonNilCollection):
            return nonNilCollection.count == 0
        default:
            return true
        }
    }
}
