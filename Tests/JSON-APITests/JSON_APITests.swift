import XCTest
@testable import JSON_API

final class JSON_APITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(JSON_API().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
