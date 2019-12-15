//
//  Created by Joseph Van Boxtel on 12/14/19.
//

import Foundation

/// This is specific to Planning Center's implementation of the spec.
public struct APIError: Error, Codable {
    public var code: String
    public var title: String
    public var detail: String
}
