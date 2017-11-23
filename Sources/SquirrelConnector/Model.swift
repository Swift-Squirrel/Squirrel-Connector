//
//  Model.swift
//  Migration
//
//  Created by Filip Klembara on 8/1/17.
//
//

import MongoKitten
import Foundation
@_exported import MongoKitten

/// Model protocol
public protocol Model: Codable {

    /// database id of model
    var _id: ObjectId? { get set }
}

// MARK: - Model functions to work with database
extension Model {
    private static var modelName: String {
        return String(describing: Self.self).lowercased() + "s"
    }

    private static var connector: MongoKitten.Database {
        return Connector.connector
    }

    /// Collection of objects stored in database
    public static var collection: MongoKitten.Collection {
        return connector[modelName]
    }

    /// Json representation
    public var json: String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self) // swiftlint:disable:this force_try
        return String(data: data, encoding: .utf8)!
    }

    /// Prepare database to storing object of this type
    ///
    /// - Throws: When unable to send the request/receive the response,
    /// the authenticated user doesn’t have sufficient permissions or an error occurred
    public static func create() throws {
        try connector.createCollection(named: modelName)
    }

    /// Drop all objects of this type from database
    ///
    /// - Throws: When unable to send the request/receive the response,
    /// the authenticated user doesn’t have sufficient permissions or an error occurred
    public static func drop() throws {
        try collection.drop()
    }

    /// Save object to database and set id
    ///
    /// - Note: If id is set this update or create existing object in database
    ///
    /// - Postconditions: `id` is not nil
    ///
    /// - Throws: Errors
    public mutating func save() throws {
        let collection = Self.collection
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        var doc = try Document(extendedJSON: Array(data))!
        let ref = try doc.upsert(into: collection)

        if self._id == nil {
            guard let newID = ref.id as? ObjectId else {
                return
            }
            self._id = newID
        }
    }

    /// Remove object from database
    ///
    /// - Precondition: `id` is not nil
    /// - Postcondition: `id` is nil
    ///
    /// - Throws: Errors
    public mutating func remove() throws {
        guard let id = self._id else {
            return
        }
        let collection = Self.collection
        try collection.remove("_id" == id, limitedTo: 1)
        self._id = nil
    }
}

// MARK: - Array<Model> functions
extension Array where Element: Model {
    /// Json representation
    public var json: String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self) // swiftlint:disable:this force_try
        return String(data: data, encoding: .utf8)!
    }

    /// Save object to database and set ids
    ///
    /// - Note: If id is set this update or create existing object in database
    ///
    /// - Postconditions: `id` is not nil
    ///
    /// - Throws: Errors
    public mutating func saveAllDocuments() throws {
        for index in 0..<count {
            try self[index].save()
        }
    }

    /// Remove objects from database
    ///
    /// - Precondition: `id` is not nil
    /// - Postcondition: `id` is nil
    ///
    /// - Throws: Errors
    public mutating func removeAllDocuments() throws {
        for index in 0..<count {
            try self[index].remove()
        }
    }
}
