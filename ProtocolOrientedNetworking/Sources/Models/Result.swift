//
//  Result.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 13/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation

public enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}
