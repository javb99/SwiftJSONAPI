//
//  Document.swift
//  
//
//  Created by Joseph Van Boxtel on 6/16/19.
//

import Foundation

/// This protocol allows references to the type without specifying each associated type.
public protocol DocumentProtocol: Codable {
    associatedtype Data: Codable
    associatedtype Included: Codable
    associatedtype Errors: Codable
    associatedtype Meta: Codable
    associatedtype Links: Codable
    associatedtype Spec: Codable
}

/// The structure of responses and requests according the JSON:API.
/// Must contain at least one of `data`, `errors`, or `meta`, but `errors` and `data` must not both be present.
public struct Document<Data, Included, Errors, Meta, Links, Spec>: DocumentProtocol
where Data: Codable,
  Included: Codable,
    Errors: Codable,
      Meta: Codable,
     Links: Codable,
      Spec: Codable {
    
    // MARK: - Key Top Level Members
    
    ///  A document *MUST* contain at least one of the following top-level members
    ///  The members `data` and `errors` *MUST NOT* coexist in the same document.
    
    /// The primary data
    /// Single or an array of `Resource` objects or `ResourceIdentifier` objects, can be empty.
    public var data: Data?
    
    /// An array of `Error` objects
    public var errors: Errors?
    
    /// Non-standard meta information
    public var meta: Meta?
    
    // MARK: - Top Level Members
    
    /// A `Links` object that relates to the primary data such as `self` and pagination links.
    public var links: Links?
    
    /// An array of `resource` objects that are related to the primary data.
    /// Must be `nil` if `data` is `nil`.
    public var included: Included?
    
    /// An object describing the server’s implementation
    public var jsonapi: Spec?
    
    // MARK: - Initializers
    // These initializers protect some of the basic integrity of the structure.
    
    /// Create a document for data
    public init(data: Data, included: Included? = nil, links: Links? = nil, meta: Meta? = nil, jsonapi: Spec? = nil) {
        self.data = data
        self.errors = nil
        self.meta = meta
        self.links = links
        self.included = included
        self.jsonapi = jsonapi
    }
    
    /// Create a document for errors.
    public init(errors: Errors, meta: Meta? = nil, links: Links? = nil, jsonapi: Spec? = nil) {
        self.data = nil
        self.errors = errors
        self.meta = meta
        self.links = links
        self.included = nil
        self.jsonapi = jsonapi
    }
    
    /// Create a document for meta.
    public init(meta: Meta, jsonapi: Spec? = nil) {
        self.data = nil
        self.errors = nil
        self.meta = meta
        self.links = nil
        self.included = nil
        self.jsonapi = jsonapi
    }
    
    // MARK: - Coding Implementation
    
    enum CodingKeys: CodingKey {
        case data
        case errors
        case meta
        case links
        case included
        case jsonapi
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(Data.self, forKey: .data)
        errors = try container.decodeIfPresent(Errors.self, forKey: .errors)
        meta = try container.decodeIfPresent(Meta.self, forKey: .meta)
        links = try container.decodeIfPresent(Links.self, forKey: .links)
        included = try container.decodeIfPresent(Included.self, forKey: .included)
        jsonapi = try container.decodeIfPresent(Spec.self, forKey: .jsonapi)
        
        try verifyStructure()
    }
    
    public func encode(to encoder: Encoder) throws {
        try verifyStructure()
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .data)
        try container.encode(errors, forKey: .errors)
        try container.encode(meta, forKey: .meta)
        try container.encode(links, forKey: .links)
        try container.encode(included, forKey: .included)
        try container.encode(jsonapi, forKey: .jsonapi)
    }
    
    public func verifyStructure() throws {
        guard data != nil || errors != nil || meta != nil else {
            throw DocumentError.invalidStructure("A document MUST contain at least one of the following top-level members: 'data', 'errors', 'meta'")
        }
        
        guard data == nil || errors == nil else {
            throw DocumentError.invalidStructure("The members data and errors MUST NOT coexist in the same document.")
        }
        
        // If a document does not contain a top-level data key, the included member MUST NOT be present either.
        guard (data == nil) == (included == nil) else {
            throw DocumentError.invalidStructure("If a document does not contain a top-level data key, the included member MUST NOT be present either.")
        }
    }
}
