//
//  ResourceDecodeError.swift
//  
//
//  Created by Joseph Van Boxtel on 6/16/19.
//

import Foundation

public enum ResourceDecodeError: Error, LocalizedError {
    case incorrectStructure(reason: String)
    case wrongType(expected: String)
    
    public var errorDescription: String {
        switch self {
        case let .incorrectStructure(reason: reason):
            return "Incorrect structure: " + reason
        case let .wrongType(expected: expectedType):
            return "Invalid type, expected: " + expectedType
        }
    }
}
