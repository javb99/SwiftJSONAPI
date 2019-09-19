//
//  DocumentTests.swift
//  
//
//  Created by Joseph Van Boxtel on 7/20/19.
//

import XCTest
@testable import JSONAPISpec

struct IntDoc: DocumentProtocol {
    
    typealias Data = [Int]
    
    typealias Included = [Int]
    
    typealias Errors = [String]
    
    typealias Meta = Empty
    
    typealias Links = Empty
    
    typealias Spec = Empty
}

final class DocumentTests: XCTestCase {
    
    func testCodableConformance() {
        let doc = Document<[Int], [Int], Empty, Empty, Empty, Empty>(data: [10, 20, 30], included: [1, 2, 3])
        let data = try! JSONEncoder.init().encode(doc)
        let parsedDoc = try! JSONDecoder.init().decode(Document<[Int], [Int], Empty, Empty, Empty, Empty>.self, from: data)
        var before = ""
        dump(doc, to: &before)
        var after = ""
        dump(parsedDoc, to: &after)
        XCTAssertEqual(before, after)
    }
    
    static var allTests = [
        ("testCodableConformance", testCodableConformance),
    ]
}
