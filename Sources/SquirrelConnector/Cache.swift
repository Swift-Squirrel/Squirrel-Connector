//
//  Cache.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/30/17.
//

import SquirrelCache
import MongoKitten
import Foundation

/// Squirrel connector cache
public struct SquirrelConnectorCache {

    /// Default name for cache
    public static let defaultName = "ProjectionCache"

    static var cache: SpecializedCache<Projection> = SpecializedCache(name: defaultName)

    /// Set projection cache manager
    ///
    /// - Parameters:
    ///   - name: name of cache folder
    ///   - config: Configuration
    public static func setProjectionCache(name: String = defaultName, config: Config) {
        cache = SpecializedCache(name: name, config: config)
    }

    /// Total disk size
    public static var totalDiskSize: UInt64 {
        return (try? cache.totalDiskSize()) ?? 0
    }

    /// Name of cache
    public static var name: String {
        return cache.name
    }

    /// Path of cache directory
    public static var path: String {
        return cache.path
    }

    /// Clears the front and back cache storages.
    ///
    /// - Parameter keepRoot: Pass `true` to keep the existing disk cache directory
    /// after removing its contents. The default value is `false`.
    public static func clear(keepingRootDirectory keepRoot: Bool = false) {
        try? cache.clear(keepingRootDirectory: keepRoot)
    }

    /// Clears all expired objects from front and back storages.
    public static func clearExpired() {
        try? cache.clearExpired()
    }
}

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
