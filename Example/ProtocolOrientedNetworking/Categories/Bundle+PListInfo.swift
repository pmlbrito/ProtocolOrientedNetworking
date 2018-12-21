//
//  Bundle+PListInfo.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 13/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation

extension Bundle {
    public static func versionNumber(for bundle: Bundle) -> String {
        return bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    public static func buildNumber(for bundle: Bundle) -> String {
        return bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
}
