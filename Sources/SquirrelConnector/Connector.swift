//
//  Connector.swift
//  Migration
//
//  Created by Filip Klembara on 8/1/17.
//
//

public struct Connector {
    private init() {
        
    }

    private static var _connector: ConnectorProtocol? = nil

    /// Database connector used in models
    public static var connector: ConnectorProtocol? {
        return _connector
    }

    /// Set connector
    ///
    /// - Parameter connector: connector to set
    /// - Returns: true if previous connector was nil, otherwise false because connector can't be reset
    public static func set(connector: ConnectorProtocol) -> Bool {
        guard _connector == nil else {
            return false
        }
        _connector = connector
        return true
    }
}

/// Database connector protocol
public protocol ConnectorProtocol {
    /// Init connector with given data
    ///
    /// - Parameter data: key value data for connector
    /// - Throws: `Error if any of values are missing or invalid`
    init(with data: [String: Any]) throws

    /// Open connection
    ///
    /// - Throws: `ConnectionError` with kind: `ConnectorError.ErrorKind.cantOpenConnection`
    func open() throws

    /// Close connection
    ///
    /// - Throws: `ConnectionError` with kind: `ConnectorError.ErrorKind.cantCloseConnection`
    func close() throws

    func use() throws

    /// Drop table from database
    ///
    /// - Parameter tableName: table name
    /// - Throws: Connection and socket errors
    func drop(tableName: String) throws

    /// Create table in database
    ///
    /// - Parameters:
    ///   - table: table name
    ///   - columns: columns names
    /// - Throws: Connection and socket errors
    func create(table: String, columns: [String: String]) throws

    /// Create table in database from object
    ///
    /// - Parameter object: object template of new table
    /// - Throws: Socket errors and `ConnectionError` with kind: `.cantCreateTable(name: String, reason: String)`
    func create<T: ModelProtocol>(table object: T) throws

    /// Store object to database if there is not already object with
    /// same `id` otherwise updates object with same `id`
    ///
    /// - Parameter object: saving object
    /// - Returns: `id` of stored object
    /// - Throws: socket errors
    func save<T: ModelProtocol>(table object: T) throws -> UInt

    func deepSave<T: ModelProtocol>(table object: T) throws -> UInt
}
