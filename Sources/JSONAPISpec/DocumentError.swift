//
//  DocumentError.swift
//  
//
//  Created by Joseph Van Boxtel on 7/27/19.
//

import Foundation

public enum DocumentError: Error {
    case invalidStructure(String)
    case errorNotData(String)
    case decodeError(Error)
}
