//
//  Connector.swift
//  Migration
//
//  Created by Filip Klembara on 8/1/17.
//
//

import Foundation

public struct Connector {
    private init() {
        
    }
    public static var connector: ConnectorProtocol? = nil
}

public protocol ConnectorProtocol {
    func open() throws

    func close() throws

    func use() throws

    func drop(tableName: String) throws

    func create(table: String, columns: [String: String]) throws

    func create<T: ModelProtocol>(table object: T) throws

    func save<T: ModelProtocol>(table object: T) throws -> UInt

    func deepSave<T: ModelProtocol>(table object: T) throws -> UInt
}
