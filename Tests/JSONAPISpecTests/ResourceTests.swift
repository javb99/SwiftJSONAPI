//
//  ResourceTests.swift
//  
//
//  Created by Joseph Van Boxtel on 7/20/19.
//

import XCTest
@testable import JSONAPISpec

struct ResourceList<Type: ResourceProtocol>: DocumentProtocol {
    
    typealias Data = [Resource<Type>]
    
    typealias Included = Empty
    
    typealias Errors = Empty
    
    typealias Meta = Empty
    
    typealias Links = Empty
    
    typealias Spec = Empty
}

struct IntList: ResourceProtocol {
    struct Attributes: Codable {
        var values: [Int]
    }
    
    typealias Relationships = Empty
    
    typealias Links = Empty
    
    typealias Meta = Empty
}

fileprivate let example = """
{
    "type": "Folder",
    "id": "1",
    "attributes": {
        "created_at": "2000-01-01T12:00:00Z",
        "name": "string",
        "updated_at": "2000-01-01T12:00:00Z",
        "container": "string"
    },
    "relationships": {
        "ancestors": {
            "data": {
                "type": "Folder",
                "id": "1"
            }
        },
        "parent": {
            "data": {
                "type": "Folder",
                "id": "1"
            }
        },
        "campus": {
            "data": {
                "type": "Campus",
                "id": "1"
            }
        }
    }
}
"""

public struct Folder: ResourceProtocol {
    public struct Attributes: Codable {
        enum CodingKeys: String, CodingKey {
            case name
        }
        public var name: String?
    }
    
    public struct Relationships: Codable {
        enum CodingKeys: String, CodingKey {
            case parentID = "parent_id"
        }
        public var parentID: ResourceIdentifier<Folder>?
    }
    
    public typealias Links = Empty
    public typealias Meta = Empty
}

final class ResourceTests: XCTestCase {
    
    func testDecode() {
        let data = example.data(using: .utf8)!
        let folder = try! JSONDecoder().decode(Resource<Folder>.self, from: data)
        XCTAssertEqual(folder.name, "string")
        XCTAssertEqual(folder.identifer.id, "1")
        XCTAssertEqual(folder.identifer.type, "Folder")
    }
    
    func testCodableConformance() {
        
        let doc = ResourceCollectionDocument<IntList>(data: [])
        let data = try! JSONEncoder.init().encode(doc)
        let parsedDoc = try! JSONDecoder.init().decode(ResourceCollectionDocument<IntList>.self, from: data)
        var before = ""
        dump(doc, to: &before)
        var after = ""
        dump(parsedDoc, to: &after)
        XCTAssertEqual(before, after)
    }
    
    static var allTests = [
        ("testCodableConformance", testCodableConformance),
        ("testDecode", testDecode),
    ]
}
