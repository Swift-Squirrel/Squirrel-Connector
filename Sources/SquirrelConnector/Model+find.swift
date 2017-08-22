//
//  Model+find.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/19/17.
//
//

import MongoKitten
import Foundation

// MARK: - Find functions
extension Model {
    /// Find all documents from collection and project them to result type
    ///
    /// - Parameters:
    ///   - filter: Filtering conditions
    ///   - sort: Sort
    ///   - collation: The collation to use when comparing strings
    ///   - skip: The amount of Documents to skip before returning the matching Documents
    ///   - limit: The maximum amount of matching documents to return
    /// - Returns: Array of prejections
    /// - Throws: Some errors
    public static func find<T>(_ filter: Query? = nil,
                               sortedBy sort: Sort? = nil,
                               collation: Collation? = nil,
                               skipping skip: Int? = nil,
                               limitedTo limit: Int? = nil) throws -> [T] where T: Codable {

        return try findMore(filter,
                            sortedBy: sort,
                            collation: collation,
                            skipping: skip,
                            limitedTo: limit,
                            projection: [T].self)
    }

    /// Find all documents from collection
    ///
    /// - Parameters:
    ///   - filter: Filtering conditions
    ///   - sort: Sort
    ///   - collation: The collation to use when comparing strings
    ///   - skip: The amount of Documents to skip before returning the matching Documents
    ///   - limit: The maximum amount of matching documents to return
    /// - Returns: Array of results
    /// - Throws: Some errors
    public static func find(_ filter: Query? = nil,
                            sortedBy sort: Sort? = nil,
                            collation: Collation? = nil,
                            skipping skip: Int? = nil,
                            limitedTo limit: Int? = nil) throws -> [Self] {

        return try findMore(filter,
                            sortedBy: sort,
                            collation: collation,
                            skipping: skip,
                            limitedTo: limit,
                            projection: [Self].self)
    }

    private static func findMore<T>(_ filter: Query? = nil,
                                    sortedBy sort: Sort? = nil,
                                    collation: Collation? = nil,
                                    skipping skip: Int? = nil,
                                    limitedTo limit: Int? = nil,
                                    projection: T.Type) throws -> T where T: Codable {

        let documents = try collection.find(filter,
                                            sortedBy: sort,
                                            collation: collation,
                                            skipping: skip,
                                            limitedTo: limit)

        let data: [Any] = documents.map({ return convertToJSON(document: $0) })
        let jsonDecoder = JSONDecoder()
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        return try jsonDecoder.decode(projection, from: jsonData)
    }

    /// Find first matching document and project it to expected result
    ///
    /// - Parameters:
    ///   - filter: Filtering conditions
    ///   - sort: Sort
    ///   - collation: The collation to use when comparing strings
    ///   - skip: The amount of Documents to skip before returning the matching Document
    /// - Returns: First matching document projected to expected result or nil
    /// - Throws: Some errors
    public static func findOne<T>(_ filter: Query? = nil,
                                  sortedBy sort: Sort? = nil,
                                  collation: Collation? = nil,
                                  skipping skip: Int? = nil) throws -> T? where T: Codable {

        return try findOne(filter, sortedBy: sort, collation: collation, skipping: skip, projection: T.self)
    }

    /// Find first matching document
    ///
    /// - Parameters:
    ///   - filter: Filtering conditions
    ///   - sort: Sort
    ///   - collation: The collation to use when comparing strings
    ///   - skip: The amount of Documents to skip before returning the matching Document
    /// - Returns: First matching document or nil
    /// - Throws: Some errors
    public static func findOne(_ filter: Query? = nil,
                               sortedBy sort: Sort? = nil,
                               collation: Collation? = nil,
                               skipping skip: Int? = nil) throws -> Self? {

        return try findOne(filter, sortedBy: sort, collation: collation, skipping: skip, projection: Self.self)
    }

    private static func findOne<T>(_ filter: Query? = nil,
                                   sortedBy sort: Sort? = nil,
                                   collation: Collation? = nil,
                                   skipping skip: Int? = nil,
                                   projection: T.Type) throws -> T? where T: Codable {

        guard let document = try collection.findOne(filter, sortedBy: sort, skipping: skip, collation: collation) else {
            return nil
        }
        let data: Any = convertToJSON(document: document)
        let jsonDecoder = JSONDecoder()
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        return try jsonDecoder.decode(projection, from: jsonData)
    }
}
