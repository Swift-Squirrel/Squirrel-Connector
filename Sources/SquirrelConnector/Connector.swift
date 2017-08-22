//
//  Connector.swift
//  Migration
//
//  Created by Filip Klembara on 8/1/17.
//
//

import MongoKitten

/// Database Connector
public struct Connector {
    private init() {
    }

    private static var _connector: MongoKitten.Database!

    /// Database connector used in models
    public static var connector: MongoKitten.Database {
        return _connector
    }

    /// Set connector for database
    ///
    /// - Parameters:
    ///   - host: Host
    ///   - port: Port (default 27017)
    ///   - dbname: Database name (default squirrel)
    /// - Returns: True if operation is successful
    @discardableResult
    public static func setConnector(host: String, port: Int = 27017, dbname: String = "squirrel") -> Bool {
        do {
            _connector = try MongoKitten.Database("mongodb://" + host + ":" + String(port) + "/" + dbname)
        } catch {
            return false
        }
        return true
    }

    /// Set connector for database
    ///
    /// - Parameters:
    ///   - username: Username
    ///   - password: Password
    ///   - host: Host
    ///   - port: Port (default 27017)
    ///   - dbname: Database name (default squirrel)
    /// - Returns: True if operation is successful
    @discardableResult
    public static func setConnector(username: String,
                                    password: String,
                                    host: String,
                                    port: Int = 27017,
                                    dbname: String = "squirrel") -> Bool {
        do {
            _connector = try MongoKitten.Database("mongodb://\(username):\(password)@\(host):\(port)/\(dbname)")
        } catch {
            return false
        }
        return true
    }
}
