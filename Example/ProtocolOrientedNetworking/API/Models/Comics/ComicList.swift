//
//  ComicList.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 19/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

//PagedResults
struct ComicList: Codable {
    let available: Int?
    let returned: Int?
    //collectionURI (string, optional): The path to the full list of issues in this collection.,
    let items: [ComicSummary]?
}
