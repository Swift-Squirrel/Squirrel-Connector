//
//  ObjectId+Codable.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/22/17.
//

import MongoKitten
import Foundation

// MARK: - ObjectId Codable
extension ObjectId: Codable {
    /// Decoder excepcting `String` value or `[String: String]` value with key `id` or `$oid`
    ///
    /// - Parameter decoder: decoder
    /// - Throws: If value is not correct hexString or decoding errors
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            try self.init(value)
        } else {
            let value = try container.decode([String: String].self)
            if let id = value["id"] {
                try self.init(id)
            } else if let id = value["$oid"] {
                try self.init(id)
            } else {
                throw ConnectorError(kind: .missingID)
            }
        }
    }

    /// Ecoder
    ///
    /// - Parameter encoder: Encoder
    /// - Throws: Encoding error
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(hexString)
    }
}
