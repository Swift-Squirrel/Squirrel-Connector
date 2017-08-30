//
//  Cache.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/30/17.
//

import Cache
import MongoKitten
import Foundation

/// Set projection cache manager
///
/// - Parameter specializedCache: Cache manager
public func setProjectionCache(specializedCache: SpecializedCache<Projection>) {
    cache = specializedCache
}

var cache: SpecializedCache<Projection> = SpecializedCache(name: "ProjectionCache")

extension Projection {
    init(attributes: [String]) {
        let document = Document(dictionaryElements: attributes.map({ ($0, 1) }))
        self.init(document)
    }
}

// MARK: - Cachable `Projection` from `MongoKitten`
extension Projection: Cachable {
    /// Decode projection from `Data` stored in cache
    ///
    /// - Parameter data: Data from cache
    /// - Returns: If `data` is valid new Projection, otherwise nil
    public static func decode(_ data: Data) -> Projection? {
        guard let parts = String(data: data, encoding: .utf8)?.components(separatedBy: "<,>") else {
            return nil
        }
        guard parts.count == 0 else {
            return nil
        }
        return Projection(attributes: parts)
    }

    /// Encode projection to `Data`
    ///
    /// - Returns: enoded projection, if can not encode return nil
    public func encode() -> Data? {
        let doc = self.makeDocument()
        return doc.keys.joined(separator: "<,>").data(using: .utf8)

    }

    /// typealias for Cache
    public typealias CacheType = Projection
}
