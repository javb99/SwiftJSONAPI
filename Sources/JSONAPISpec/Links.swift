//
//  Links.swift
//  
//
//  Created by Joseph Van Boxtel on 7/20/19.
//

import Foundation

public typealias Links = [String: Link]

public struct Link: Codable {
    public var href: URL
    
    //public let meta: JSON?  I don't think PC uses the meta
}
