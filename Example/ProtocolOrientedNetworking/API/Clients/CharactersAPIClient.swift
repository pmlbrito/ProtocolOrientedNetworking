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
    var config: APIConfigurable
    
    init(apiConfig: APIConfigurable) {
        self.config = apiConfig
    }
    
    func getCharactersList(size: Int, offset: Int, completion: @escaping (Result<CharactersListResponse?, PONetworkingError>) -> Void) {
        let endPoint = CharactersEndpoint(configuration: self.config, route: .list_caracters(offset: offset, pageSize: size))
        execute(with: endPoint.request, decode: { json -> CharactersListResponse? in
            guard let charactersResult = json as? CharactersListResponse else { return nil }
            return charactersResult
        }, completion: completion)
    }
    
    func getCharacterImage(imageURL: URL, completion: @escaping (Result<UIImage?, PONetworkingError>) -> Void) {
        let endPoint = CharactersEndpoint(configuration: self.config, route: .download_image(imageURL: imageURL))
        executeForImageDownload(with: endPoint.request, completion: completion)
    }
    
    func getCharacterImageFor(imageURL: URL, imageView: UIImageView?) {
        let endPoint = CharactersEndpoint(configuration: self.config, route: .download_image(imageURL: imageURL))
        executeForImageDownload(with: endPoint.request) { (result) in
            switch result {
            case .success(let image):
                imageView?.image = image
                break
            case .failure(let error):
                NSLog("Error loading image: %@", error.localizedDescription)
                imageView?.image = UIImage(named: "thumb_not_available")
            }
        }
    }
}

