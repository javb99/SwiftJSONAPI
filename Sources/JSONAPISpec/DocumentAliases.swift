//
//  DocumentAliases.swift
//  
//
//  Created by Joseph Van Boxtel on 7/27/19.
//

import Foundation

/// A document for an array of resources.
public typealias ResourceCollectionDocument<Type: ResourceProtocol> = Document<[Resource<Type>], Empty, [APIError], CountMeta, Empty, Empty>

public typealias ResourceCollectionIncludesDocument<Type: ResourceProtocol, Includes: Codable> = Document<[Resource<Type>], Includes, [APIError], CountMeta, Empty, Empty>

/// A document for a single resource.
public typealias ResourceDocument<Type: ResourceProtocol> = Document<Resource<Type>, Empty, [APIError], Empty, Empty, Empty>
