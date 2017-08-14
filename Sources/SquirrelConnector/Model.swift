//
//  Model.swift
//  Migration
//
//  Created by Filip Klembara on 8/1/17.
//
//

/// Model protocol
public protocol ModelProtocol {
    init()

    /// database id of model, 0 (zero) means not set
    var id: UInt { get set }
}

// MARK: - Model functions to work with database
extension ModelProtocol {

    /// Prepare database to storing object of this type
    ///
    /// - Throws: socket errors and `ConnectorError`
    public final func create() throws {
        guard let connector = Connector.connector else {
            throw ConnectorError(kind: .noConnector)
        }
        try connector.open()
        try connector.create(table: self)

    }


    /// Drop all objects of this type from database
    ///
    /// - Throws: socket errors and `ConnectorError`
    public final func drop() throws {
        guard let connector = Connector.connector else {
            throw ConnectorError(kind: .noConnector)
        }
        try connector.open()
        let name = String(describing: type(of: self)) + "S"
        try connector.drop(tableName: name)
    }


    /// Store object primitive values to database
    ///
    /// - Note: `id` is zero this set new `id`
    /// 
    /// - Important: This will not store arrays of type `ModelProtocol` if you want to save all attributes use `deepSave()`
    ///
    /// - Throws: socket errors and `ConnectorError`
    mutating public final func save() throws {
        guard let connector = Connector.connector else {
            throw ConnectorError(kind: .noConnector)
        }
        try connector.open()
        self.id = try connector.save(table: self)
    }


    /// Store object values to database (arrays of type `ModelProtocol` including)
    ///
    /// - Note: If `id` is zero this set new `id`
    ///
    /// - Throws: socket errors and `ConnectorError`
    mutating public final func deepSave() throws {
        guard let connector = Connector.connector else {
            throw ConnectorError(kind: .noConnector)
        }
        try connector.open()
        self.id = try connector.deepSave(table: self)
    }
}
