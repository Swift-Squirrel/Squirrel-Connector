//
//  Convert.swift
//  SquirrelConnectorPackageDescription
//
//  Created by Filip Klembara on 8/22/17.
//

import MongoKitten
import Foundation

// swiftlint:disable:next cyclomatic_complexity
func convert<T>(object: T) -> [(String, MongoKitten.Primitive?)] where T: Model {
    let mirror = Mirror(reflecting: object)
    let children = mirror.children
    var res: [(String, MongoKitten.Primitive?)] = []
    for child in children {
        guard let name = child.label else {
            continue
        }

        if name == "id" {
            if let value = child.value as? ObjectId {
                res.append(("_id", value))
            }
            continue
        }

        switch child.value {
        case let arr as [MongoKitten.Primitive]:
            res.append((name, arr))
        case let arr as [Any]:
            res.append((name, arr.map({ convertDic(dic: $0) })))
        case let dic as [String: MongoKitten.Primitive]:
            res.append((name, dic))
        case let dic as [String: Any]:
            var pom: [String: MongoKitten.Primitive] = [:]
            for item in dic {
                pom[item.key] = convertDic(dic: item.value)
            }
            res.append((name, pom))
        case let prim as MongoKitten.Primitive:
            res.append((name, prim))
        default:
            res.append((name, convertDic(dic: child.value)))
        }
    }
    return res
}

func convertDic<T>(dic: T) -> [String: MongoKitten.Primitive] {
    let mirror = Mirror(reflecting: dic)
    let children = mirror.children
    var res: [String: MongoKitten.Primitive] = [:]
    for child in children {
        guard let name = child.label else {
            continue
        }
        switch child.value {
        case let arr as [MongoKitten.Primitive]:
            res[name] = arr
        case let arr as [Any]:
            res[name] = arr.map({ convertDic(dic: $0) })
        case let dic as [String: MongoKitten.Primitive]:
            res[name] = dic
        case let dic as [String: Any]:
            var pom: [String: MongoKitten.Primitive] = [:]
            for item in dic {
                pom[item.key] = convertDic(dic: item.value)
            }
            res[name] = pom
        case let prim as MongoKitten.Primitive:
            res[name] = prim
        default:
            res[name] = convertDic(dic: child.value)
        }
    }
    return res
}

func convertToJSON(document: Document) -> [String: Any] {
    var res: [String: Any] = [:]
    for (key, value) in document {
        var key = key
        if key == "_id" {
            key = "id"
        }
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
            guard let val = value as? Document else {
                continue
            }
            res.append(convertToJSONAny(document: val))
        }
        return res
    } else {
        var res: [String: Any] = [:]
        for (key, value) in document {
            var key = key
            if key == "_id" {
                key = "id"
            }
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
