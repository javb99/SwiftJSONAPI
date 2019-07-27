//
//  Resource.swift
//  
//
//  Created by Joseph Van Boxtel on 7/20/19.
//

import Foundation

public protocol ResourceProtocol: ResourceTypeNameProviding {
    associatedtype Attributes: Codable
    associatedtype Relationships: Codable
    associatedtype Links: Codable
    associatedtype Meta: Codable
}

@dynamicMemberLookup
public struct Resource<Type>: Codable where Type: ResourceProtocol {
    
    public var identifer: ResourceIdentifier<Type>
    
    public var links: Type.Links?
    
    private var relationships: Type.Relationships?
    
    /// Members represent the attributes of the resource.
    ///
    /// Complex data structures involving JSON objects and arrays are allowed as attribute values.
    /// However, any object that constitutes or is contained in an attribute *MUST NOT* contain a relationships or links member, as those members are reserved by this specification for future use.
    ///
    /// Although has-one foreign keys (e.g. author_id) are often stored internally alongside other information to be represented in a resource object, these keys *SHOULD NOT* appear as attributes.
    private var attributes: Type.Attributes
    
    public var meta: Type.Meta?
    
    /// Give access to the attributes as first class members.
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Type.Attributes, T>) -> T {
        get { self.attributes[keyPath: keyPath] }
        set { self.attributes[keyPath: keyPath] = newValue }
    }
    
    /// Give access to the relationships as first class members.
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Type.Relationships, T>) -> T {
        get { self.relationships![keyPath: keyPath] }
        set { self.relationships?[keyPath: keyPath] = newValue }
    }
}
