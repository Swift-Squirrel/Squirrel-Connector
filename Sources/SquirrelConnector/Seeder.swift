//
//  Seeder.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/13/17.
//
//

/// Seeder protocol
public protocol Seeder {
    /// Initialize seeder
    init()

    /// Theese models will be stored in database during seeding
    var models: [Model] { get }

    /// Set up models variable, this method will be called before seeding
    ///
    /// - Throws: User defined errors
    mutating func setUp() throws
}
