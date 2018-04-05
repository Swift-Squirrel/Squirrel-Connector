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
                               limitedTo limit: Int? = nil,
                               resultType: T.Type = T.self) throws -> [T] where T: Projectable {
        let projection = T.projection
        return try findMore(filter,
                            sortedBy: sort,
                            collation: collation,
                            skipping: skip,
                            limitedTo: limit,
                            projecting: projection)
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
                            limitedTo: limit)
    }

    private static func findMore<T>(_ filter: Query? = nil,
                                    sortedBy sort: Sort? = nil,
                                    collation: Collation? = nil,
                                    skipping skip: Int? = nil,
                                    limitedTo limit: Int? = nil,
                                    projecting projection: Projection? = nil
        ) throws -> [T] where T: Decodable {

        let documents = try collection.find(filter,
                                            sortedBy: sort,
                                            projecting: projection,
                                            collation: collation,
                                            skipping: skip,
                                            limitedTo: limit)

        let data: [Any] = documents.map({ return convertToJSON(document: $0) })
        let jsonDecoder = JSONDecoder()
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        return try jsonDecoder.decode([T].self, from: jsonData)
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
                                  skipping skip: Int? = nil,
                                  resultType: T.Type = T.self) throws -> T? where T: Projectable {

        let projection = T.projection
        return try findOneDocument(
            filter,
            sortedBy: sort,
            projecting: projection,
            collation: collation,
            skipping: skip)
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

        return try findOneDocument(filter, sortedBy: sort, collation: collation, skipping: skip)
    }

    private static func findOneDocument<T>(_ filter: Query? = nil,
                                           sortedBy sort: Sort? = nil,
                                           projecting projection: Projection? = nil,
                                           collation: Collation? = nil,
                                           skipping skip: Int? = nil) throws -> T?
        where T: Codable {

        guard let document = try collection.findOne(
            filter,
            sortedBy: sort,
            projecting: projection,
            skipping: skip,
            collation: collation) else {

            return nil
        }
        let data: Any = convertToJSON(document: document)
        let jsonDecoder = JSONDecoder()
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        return try jsonDecoder.decode(T.self, from: jsonData)
    }
}

// MARK: - Distinct
extension Model {
    /// Distinct on given key
    ///
    /// - Parameters:
    ///   - key: Key
    ///   - query: Filter query
    ///   - readConcern: Read concern
    ///   - collation: Collation
    ///   - resultType: Result type
    /// - Returns: Array of results in given type
    /// - Throws: MongoDB errors
    public static func distinct<T: Primitive>(on key: String,
                                              filtering query: Query? = nil,
                                              readConcern: ReadConcern? = nil,
                                              collation: Collation? = nil,
                                              resultType: T.Type = T.self) throws -> [T] {
        guard let res = try collection.distinct(on: key,
                                                filtering: query,
                                                readConcern: readConcern,
                                                collation: collation) else {
                                                    return []
        }
        #if swift(>=4.1)
        return res.compactMap { $0 as? T }
        #else
        return res.flatMap { $0 as? T }
        #endif
    }
}
