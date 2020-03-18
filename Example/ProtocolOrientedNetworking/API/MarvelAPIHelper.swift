//
//  MarvelAPIHelper.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 20/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation
import CommonCrypto

class MarvelAPIHelper {
    static func MD5(_ string: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let d = string.data(using: String.Encoding.utf8) {
            d.withUnsafeBytes { buffer in
                _ = CC_MD5(buffer.baseAddress!, CC_LONG(buffer.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
