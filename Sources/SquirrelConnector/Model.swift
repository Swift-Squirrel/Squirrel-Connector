//
//  Model.swift
//  Migration
//
//  Created by Filip Klembara on 8/1/17.
//
//


public protocol ModelProtocol {
    init()
}

extension ModelProtocol {
    public final func create() {
        if let connector = Connector.connector {
            try! connector.open()
            try! connector.create(table: self)
            try! connector.close()
        }
    }

    public final func drop() {
        let name = Mirror(reflecting: self).description.components(separatedBy: " ")[2] + "S"
        try! Connector.connector?.drop(tableName: name)
    }
//    func migration()
}


