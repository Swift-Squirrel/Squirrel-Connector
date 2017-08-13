//
//  ConnectorError.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/13/17.
//
//

import Foundation

public struct ConnectorError: Error, CustomStringConvertible {
    public enum ErrorKind {
        case noConnector
        case cantOpenConnection
        case cantCloseConnection
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
            return "Can not open connection"
        case .cantCloseConnection:
            return "Can not close connection"
        }
    }
}
