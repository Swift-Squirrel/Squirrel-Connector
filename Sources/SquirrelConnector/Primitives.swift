//
//  Primitives.swift
//  Migration
//
//  Created by Filip Klembara on 8/1/17.
//
//

import Foundation

/// Primitive
public protocol Primitive { }

extension UInt8: Primitive { }

extension UInt16: Primitive { }

extension UInt32: Primitive { }

extension UInt64: Primitive { }

extension UInt: Primitive { }

extension Int8: Primitive { }

extension Int16: Primitive { }

extension Int32: Primitive { }

extension Int64: Primitive { }

extension Int: Primitive { }

extension Double: Primitive { }

extension Float: Primitive { }

extension Bool: Primitive { }

extension String: Primitive { }

extension Date: Primitive { }
