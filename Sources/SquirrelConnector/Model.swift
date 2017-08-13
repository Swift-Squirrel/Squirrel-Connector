//
//  Model.swift
//  Migration
//
//  Created by Filip Klembara on 8/1/17.
//
//


public protocol ModelProtocol {
    init()

    var id: UInt { get set }
}

extension ModelProtocol {
    public final func create() throws {
        guard let connector = Connector.connector else {
            throw ConnectorError(kind: .noConnector)
        }
        try connector.open()
        try connector.create(table: self)
        try connector.close()

    }

    public final func drop() throws {
        guard let connector = Connector.connector else {
            throw ConnectorError(kind: .noConnector)
        }
        try connector.open()
        let name = String(describing: type(of: self)) + "S"
        try connector.drop(tableName: name)
        try connector.close()
    }

    mutating public final func save() throws {
        guard let connector = Connector.connector else {
            throw ConnectorError(kind: .noConnector)
        }
        self.id = try connector.save(table: self)
    }

    mutating public final func deepSave() throws {
        guard let connector = Connector.connector else {
            throw ConnectorError(kind: .noConnector)
        }
        self.id = try connector.deepSave(table: self)
    }
}
