//
//  Relationship.swift
//  
//
//  Created by Joseph Van Boxtel on 7/28/19.
//

import Foundation

public struct ToOneRelationship<T>: Codable where T: ResourceProtocol {
    public var data: ResourceIdentifier<T>?
}

public struct ToManyRelationship<T>: Codable where T: ResourceProtocol {
    public var data: [ResourceIdentifier<T>]?
}

