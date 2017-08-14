//
//  Seeder.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/13/17.
//
//

public protocol SeederProtocol {
    init()

    /// Theese models will be stored in database during seeding
    var models: [ModelProtocol] { get }

    /// Set up models variable, this method will be called before seeding
    ///
    /// - Throws: User defined errors
    mutating func setUp() throws
}
