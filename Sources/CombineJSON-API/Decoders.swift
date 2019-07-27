//
//  Decoders.swift
//  
//
//  Created by Joseph Van Boxtel on 7/27/19.
//

import Foundation
import Combine
import JSON_API

extension Publisher where Output == JSONDecoder.Input {
    
    public func decodeDocument<Doc>(type: Doc.Type = Doc.self, decoder: JSONDecoder = .init()) -> Publishers.Decode<Self, Doc, JSONDecoder>
    where Doc: DocumentProtocol {
        
        decode(type: Doc.self, decoder: decoder)
    }
    
    public func decodeResourceDocument<ResType>(type: ResType.Type = ResType.self, decoder: JSONDecoder = .init()) -> AnyPublisher<Resource<ResType>, DocumentError>
        where ResType: ResourceProtocol {
            
            self.decode(type: ResourceDocument<ResType>.self, decoder: decoder)
                .mapError { DocumentError.decodeError($0) }
                .eraseToAnyPublisher()
                .tryMap { resourceDoc -> Resource<ResType> in
                    guard let resource = resourceDoc.data else {
                        throw DocumentError.errorNotData(String(describing: resourceDoc.errors))
                    }
                    return resource
                }
                // The above closure doesn't throw other kinds of errors.
                .mapError { $0 as! DocumentError }
                .eraseToAnyPublisher()
    }
    
    public func decodeResourceCollectionDocument<ResType>(type: ResType.Type = ResType.self, decoder: JSONDecoder = .init()) -> AnyPublisher<ResourceDocument<ResType>, DocumentError>
        where ResType: ResourceProtocol {
            
            self.decode(type: ResourceDocument<ResType>.self, decoder: decoder)
                .mapError { $0 as! DocumentError }
                .eraseToAnyPublisher()
    }
    
    public func decodeResourceCollection<ResType>(type: ResType.Type = ResType.self, decoder: JSONDecoder = .init()) -> AnyPublisher<[Resource<ResType>], DocumentError>
        where ResType: ResourceProtocol {
            
            self.decode(type: ResourceCollectionDocument<ResType>.self, decoder: decoder)
                .mapError { DocumentError.decodeError($0) }
                .eraseToAnyPublisher()
                .tryMap { doc -> [Resource<ResType>] in
                    guard let resourceCollection = doc.data else {
                        throw DocumentError.errorNotData(String(describing: doc.errors))
                    }
                    return resourceCollection
                }
                // The above closure doesn't throw other kinds of errors.
                .mapError { $0 as! DocumentError }
                .eraseToAnyPublisher()
    }
    
}
