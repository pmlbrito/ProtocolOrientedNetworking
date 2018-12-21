//
//  Character.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 19/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation

struct Character: Codable {
    let id: Int?
    let name: String?
    let description: String?
    //resourceURI (string, optional): The canonical URL identifier for this resource.,
    let urls: [MarvelUrl]?
    let thumbnail: MarvelImage?
    let comics: ComicList?
    //stories (StoryList, optional): A resource list of stories in which this character appears.,
    //events (EventList, optional): A resource list of events in which this character appears.,
    //series (SeriesList, optional): A resource list of series in which this character appears.
}
