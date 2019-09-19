//
//  Resource.swift
//  
//
//  Created by Joseph Van Boxtel on 7/20/19.
//

import Foundation

//public protocol ResourceIdentifierIndexable {
//    subscript<T>(id: ResourceIdentifier<T>) -> Resource<T> where T: ResourceProtocol { get }
//}
//
//extension ResourceCollection: ResourceIdentifierIndexable {
//    public subscript(id: ResourceIdentifier<Type>) -> Resource<Type> where T : ResourceProtocol {
//        return self.backingStore.first(where: { resource in
//            return resource.identifer == id
//        })!
//    }
//}

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
    /// However, any object that constitutes or is contained in an attribute *MUST NOT* contain a relationships
    /// or links member, as those members are reserved by this specification for future use.
    ///
    /// Although has-one foreign keys (e.g. author_id) are often stored internally alongside other information
    /// to be represented in a resource object, these keys *SHOULD NOT* appear as attributes.
    private var attributes: Type.Attributes
    
    public var meta: Type.Meta?
    
    enum CodingKeys: CodingKey {
        case id
        case type
        case links
        case relationships
        case attributes
        case meta
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id        = try container.decode(String.self, forKey: .id)
        let type      = try container.decode(String.self, forKey: .type)
        identifer     = try AnyResourceIdentifier(type: type, id: id).specialize()
        
        links         = try container.decodeIfPresent(Type.Links.self, forKey: .links)
        relationships = try container.decodeIfPresent(Type.Relationships.self, forKey: .relationships)
        attributes    = try container.decode(Type.Attributes.self, forKey: .attributes)
        meta          = try container.decodeIfPresent(Type.Meta.self, forKey: .meta)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(identifer.id, forKey: .id)
        try container.encodeIfPresent(identifer.type, forKey: .type)
        try container.encodeIfPresent(links, forKey: .links)
        try container.encodeIfPresent(relationships, forKey: .relationships)
        try container.encodeIfPresent(attributes, forKey: .attributes)
        try container.encodeIfPresent(meta, forKey: .meta)
    }
    
    internal init(identifer: ResourceIdentifier<Type>, links: Type.Links?, relationships: Type.Relationships?, attributes: Type.Attributes, meta: Type.Meta?) {
        self.identifer = identifer
        self.links = links
        self.relationships = relationships
        self.attributes = attributes
        self.meta = meta
    }
    
    /// Give access to the attributes as first class members.
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Type.Attributes, T>) -> T {
        get { self.attributes[keyPath: keyPath] }
        set { self.attributes[keyPath: keyPath] = newValue }
    }
    
    /// Give access to the relationships as first class members.
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Type.Relationships, T>) -> T {
        get { self.relationships![keyPath: keyPath] }
        set { self.relationships?[keyPath: keyPath] = newValue }
    }
}

extension Resource: Hashable {
    
    /// For now just compares the identifier/type pair. This is fine for a client as an identity check but not for changing contents.
    public static func == (lhs: Resource<Type>, rhs: Resource<Type>) -> Bool {
        // The hash of the id is already unique across all the objects in the API.
        lhs.identifer == rhs.identifer
    }
    
    public func hash(into hasher: inout Hasher) {
        // The hash of the id is already unique across all the objects in the API.
        identifer.hash(into: &hasher)
    }
}
