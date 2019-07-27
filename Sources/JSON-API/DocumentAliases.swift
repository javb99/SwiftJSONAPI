//
//  DocumentAliases.swift
//  
//
//  Created by Joseph Van Boxtel on 7/27/19.
//

import Foundation

/// A document for an array of resources.
public typealias ResourceCollectionDocument<Type: ResourceProtocol> = Document<[Resource<Type>], Empty, Empty, Empty, Empty, Empty>

/// A document for a single resource.
public typealias ResourceDocument<Type: ResourceProtocol> = Document<Resource<Type>, Empty, Empty, Empty, Empty, Empty>
