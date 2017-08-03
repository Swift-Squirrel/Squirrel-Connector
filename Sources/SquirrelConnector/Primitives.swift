//
//  Primitives.swift
//  Migration
//
//  Created by Filip Klembara on 8/1/17.
//
//

public protocol Primitive {
    var mysqlType: String { get }
}

extension UInt8: Primitive {
    public var mysqlType: String {
        return "TINYINT UNSIGNED"
    }
 }
extension UInt16: Primitive {
    public var mysqlType: String {
        return "SMALLINT UNSIGNED"
    }
 }
extension UInt32: Primitive {
    public var mysqlType: String {
        return "INT UNSIGNED"
    }
 }
extension UInt64: Primitive {
    public var mysqlType: String {
        return "BIGINT UNSIGNED"
    }
}
extension UInt: Primitive {
    public var mysqlType: String {
        return "BIGINT UNSIGNED"
    }
}
extension Int8: Primitive {
    public var mysqlType: String {
        return "TINYINT"
    }
}
extension Int16: Primitive {
    public var mysqlType: String {
        return "SMALLINT"
    }
}
extension Int32: Primitive {
    public var mysqlType: String {
        return "INT"
    }
}
extension Int64: Primitive {
    public var mysqlType: String {
        return "BIGINT"
    }
}
extension Int: Primitive {
    public var mysqlType: String {
        return "BIGINT"
    }
}
extension Double: Primitive {
    public var mysqlType: String {
        return "DOUBLE(16)"
    }
 }
extension Float: Primitive {
    public var mysqlType: String {
        return "FLOAT(6)"
    }
 }
extension Bool: Primitive {
    public var mysqlType: String {
        return "BOOL"
    }
 }
extension String: Primitive {
    public var mysqlType: String {
        return "TEXT"
    }
 }

