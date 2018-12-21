//
//  CharactersAPIClient.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 20/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation
import ProtocolOrientedNetworking


class CharactersAPIClient: APIClient {
    
    func getCharactersList(size: Int, offset: Int, completion: @escaping (Result<CharactersListResponse?,
        PONetworkingError>) -> Void) {
        let endPoint = CharactersEndpoint.list_caracters(offset: offset, pageSize: size)
        execute(with: endPoint.request, decode: { json -> CharactersListResponse? in
            guard let charactersResult = json as? CharactersListResponse else { return  nil }
            return charactersResult
        }, completion: completion)
    }
}

