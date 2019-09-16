//
//  ResourceIdentifier.swift
//  
//
//  Created by Joseph Van Boxtel on 6/17/19.
//

import Foundation

// MARK: - Definition

/// Identifiers are unique across the entire API as a type/id pair.
public protocol ResourceIdentifierType: Hashable, Codable {
    
    var type: String { get }
    
    var id: String { get }
    
    //var meta: JSON? { get }
}

// MARK: - Specified


public protocol ResourceTypeNameProviding {
    
    /// The type of JSON:API object.
    static var resourceType: String { get }
}

extension ResourceTypeNameProviding {
    
    /// Provide a default that just lowercases the type name.
    public static var resourceType: String { String(describing: Self.self) }
}

public struct ResourceIdentifier<T: ResourceTypeNameProviding>: ResourceIdentifierType, Codable {
    
    public var type: String {
        return T.resourceType
    }
    
    public var id: String
    
    //public var meta: JSON? = nil
    
    public func eraseToAny() -> AnyResourceIdentifier {
        return AnyResourceIdentifier(type: type, id: id)
        //return AnyResourceIdentifier(type: type, id: id, meta: meta)
    }
    
    public static func raw(_ rawID: String) -> Self {
        Self(id: rawID)
    }
}

extension ResourceIdentifier: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self.init(id: value)
    }
}

// MARK: - Type Erased

public struct AnyResourceIdentifier: ResourceIdentifierType, Codable {
    
    public var type: String
    
    public var id: String
    
    //public var meta: JSON? = nil
    
    /// Effectively casts from an unknown resource identifier to a known type.
    /// Throws an error if the type doesn't match the resource type of the generic type.
    public func specialize<T>(to valueType: T.Type = T.self) throws -> ResourceIdentifier<T> {
        // This signature allows the call site to specify the generic
        // constraint if it is unclear or omit it if it can be easily inferred.
        
        guard self.type == valueType.resourceType else {
            throw ResourceDecodeError.wrongType(expected: valueType.resourceType)
        }
        return ResourceIdentifier<T>(id: id)
        //return ResourceIdentifier<T>(id: id, meta: meta)
    }
}

// MARK: - Equality & Hashing

extension ResourceIdentifierType {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(self.type)
    }
    
    /// Resources are equal if they have the same id and the same resource type.
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type
    }
}

/// Resources are equal if they have the same id and the same resource type.
/// This version takes two potentially different identifier types (i.e. Any or specific)
public func ==<A: ResourceIdentifierType, B: ResourceIdentifierType>(lhs: A, rhs: B) -> Bool {
    return lhs.id == rhs.id && lhs.type == rhs.type
}
