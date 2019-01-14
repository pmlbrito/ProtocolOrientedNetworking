//
//  MarvelImage.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 19/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation

enum MarvelImageType: String {
    case thumbnail_small = "landscape_small"
    case thumbnail_medium = "landscape_large"
    case thumbnail_large = "landscape_xlarge"
    
    case detail = "detail"
}

struct MarvelImage: Codable {
    let path: String?
    let fileExtension: String?
    
    private enum CodingKeys : String, CodingKey {
        case path, fileExtension = "extension"
    }
}

extension MarvelImage {
    func getImageURL(type: MarvelImageType) -> URL? {
        let picURLString = String(format: "%@/%@.%@", self.path ?? "", type.rawValue, self.fileExtension ?? "")
        let url = URL(string: picURLString)
        NSLog("PIC URL: %@", url?.absoluteString ?? "error creating picture path")
        return url
    }
}
