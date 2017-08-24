//
//  ConnectorError.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/13/17.
//
//

/// Structure of errors generated in this module
public struct ConnectorError: Error, CustomStringConvertible {
    /// Error kinds
    ///
    /// - noConnector: Connector is not set
    public enum ErrorKind {
        case noConnector
        case missingID
    }

    /// Error kind
    public let kind: ErrorKind

    init(kind: ErrorKind) {
        self.kind = kind
    }

    /// Error description
    public var description: String {
        switch kind {
        case .noConnector:
            return "Connector is not set"
        case .missingID:
            return "Missing 'id' key in dictionary"
        }
    }
}
