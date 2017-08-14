//
//  ConnectorError.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/13/17.
//
//

public struct ConnectorError: Error, CustomStringConvertible {
    public enum ErrorKind {
        case noConnector
        case cantOpenConnection
        case cantCloseConnection
        case cantCreateTable(name: String, reason: String)
        case cantInit(missing: [String])
    }

    public let kind: ErrorKind

    public init(kind: ErrorKind) {
        self.kind = kind
    }

    public var description: String {
        switch kind {
        case .noConnector:
            return "Connector is not set"
        case .cantOpenConnection:
            return "Could not open connection"
        case .cantCloseConnection:
            return "Could not close connection"
        case .cantInit(let missing):
            return "Could not init connector, missing value(s) in data: " + missing.flatMap({ "'" + $0 + "'" }).joined(separator: ", ")
        case .cantCreateTable(let name, let reason):
            return "Could not create table '\(name)' because of: '\(reason)'"
        }
    }
}
