//
//  Result.swift
//  ProtocolOrientedNetworking
//
//  Created by Pedro Brito on 13/12/2018.
//

import Foundation

public enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}
