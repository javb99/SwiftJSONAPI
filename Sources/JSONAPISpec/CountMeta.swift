//
//  Created by Joseph Van Boxtel on 11/26/19.
//

import Foundation

public struct CountMeta: Codable {
    public var totalCount: Int
    public var count: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
    }
}
