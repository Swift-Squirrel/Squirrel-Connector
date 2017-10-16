//
//  ObjectId+SquirrelJSONEncodable.swift
//  SquirrelJSON
//
//  Created by Filip Klembara on 10/9/17.
//

import SquirrelJSON

extension ObjectId: SquirrelJSONEncodable {
    /// ObjectId hexString
    public var encodedValue: Any {
        return hexString
    }
}
