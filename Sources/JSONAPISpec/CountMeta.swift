//
//  Created by Joseph Van Boxtel on 11/26/19.
//

import Foundation

public struct CountMeta: Codable {
    public var totalCount: Int
    public var count: Int
    
    public init(totalCount: Int, count: Int) {
        self.totalCount = totalCount
        self.count = count
    }
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
    }
}
