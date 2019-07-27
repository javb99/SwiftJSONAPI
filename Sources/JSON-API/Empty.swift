//
//  Empty.swift
//  
//
//  Created by Joseph Van Boxtel on 7/27/19.
//

import Foundation

/// A codable type that is just empty. In this library it has the extra meaning of not encoding properties of this type.
public struct Empty: Codable {
    public init(from decoder: Decoder) throws {}
    public func encode(to encoder: Encoder) throws {}
}
