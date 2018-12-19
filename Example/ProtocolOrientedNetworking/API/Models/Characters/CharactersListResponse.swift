//
//  CharactersListResponse.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 19/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

struct CharactersListResponse: Codable {
    let code: Int?
    let status: String?
    let data: CharactersDataContainer?
}
