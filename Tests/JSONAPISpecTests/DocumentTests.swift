//
//  DocumentTests.swift
//  
//
//  Created by Joseph Van Boxtel on 7/20/19.
//

import XCTest
@testable import JSON_API

struct IntDoc: DocumentProtocol {
    typealias Data = [Int]
    
    typealias Included = [Int]
    
    typealias Errors = [String]
    
    typealias Meta = Empty
    
    typealias Links = Empty
}

final class DocumentTests: XCTestCase {
    
    func testCodableConformance() {
        var doc = Document<[Int], [Int], Empty, Empty, Empty, Empty>()
        doc.data = [10, 20, 30]
        doc.included = [1, 2, 3]
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
