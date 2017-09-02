//
//  Projectable.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/30/17.
//

import MongoKitten

/// Object can be projectable from database
public protocol Projectable: Codable {
    init()
}

extension Projectable {
    static var projection: Projection {
        let cache = SquirrelConnectorCache.cache
        let name = String(describing: type(of: self))

        if let projection = cache.object(forKey: name) {
            return projection
        }

        let mirror = Mirror(reflecting: Self.init())
        let children = mirror.children
        let attributes = children.flatMap({ $0.label })
        let proj = Projection(attributes: attributes)
        cache.async.addObject(proj, forKey: name)
        return proj
    }
}
