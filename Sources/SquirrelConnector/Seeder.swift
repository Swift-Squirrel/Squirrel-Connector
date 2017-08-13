//
//  Seeder.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/13/17.
//
//

public protocol SeederProtocol {
    init()

    var models: [ModelProtocol] { get }

    mutating func setUp() throws
}
