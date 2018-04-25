//
//  Convert.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/22/17.
//

import MongoKitten
import Foundation

func convertToJSON(document: Document) -> [String: Any] {
    var res: [String: Any] = [:]
    for (key, value) in document {
//        var key = key
//        if key == "_id" {
//            key = "id"
//        }
        switch value {
        case let doc as Document:
            res[key] = convertToJSONAny(document: doc)
        case let id as ObjectId:
            res[key] = id.hexString
        case let date as Date:
            res[key] = Double(date.timeIntervalSinceReferenceDate)
        default:
            res[key] = value
        }
    }
    return res
}

func convertToJSONAny(document: Document) -> Any {
    if document.count == 0 {
        return []
    }
    if document.first?.key == "0" {
        var res: [Any] = []
        for (_, value) in document {
            if let val = value as? Document {
                res.append(convertToJSONAny(document: val))
            } else {
                res.append(value)
            }
        }
        return res
    } else {
        var res: [String: Any] = [:]
        for (key, value) in document {
//            var key = key
//            if key == "_id" {
//                key = "id"
//            }
            switch value {
            case let doc as Document:
                res[key] = convertToJSONAny(document: doc)
            case let id as ObjectId:
                res[key] = id.hexString
            case let date as Date:
                res[key] = Double(date.timeIntervalSinceReferenceDate)
            default:
                res[key] = value
            }
        }
        return res
    }
}
