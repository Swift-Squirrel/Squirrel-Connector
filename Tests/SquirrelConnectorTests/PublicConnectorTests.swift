//
//  PublicConnectorTests.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/19/17.
//
//

import XCTest
import SquirrelConnector
import SquirrelCache

class User: Model {
    var _id: ObjectId? = nil
    var username: String
    var role: Role

    init(username: String, role: Role) {
        self.username = username
        self.role = role
    }

    enum Role: String, Codable {
        case admin
        case user
    }
}

class PublicConnectorTests: XCTestCase {
    func testSave() {
        guard Connector.setConnector(host: "localhost", dbname: "exampledb") else {
            XCTFail()
            return
        }
        XCTAssertNoThrow(try Post.drop())
        var a = Post(title: "Dogs", body: "Dogs are not dogs!")
        XCTAssertNil(a._id)
        XCTAssertNoThrow(try a.save())
        XCTAssertNotNil(a._id)
        let id = a._id
        a.body = "Dogs are not cats!"
        XCTAssertNotNil(a._id)
        XCTAssertNoThrow(try a.save())
        XCTAssertNotNil(a._id)
        XCTAssertTrue(id == a._id)
    }

    func testMongoProjection() {
        do {
            struct proj: Projectable {
                let _id: ObjectId?
                let title: String

                init() {
                    _id = nil
                    title = ""
                }
            }
            guard Connector.setConnector(host: "localhost", dbname: "exampledb") else {
                XCTFail()
                return
            }
            XCTAssertNoThrow(try Post.drop())
            var post = Post(title: "Titliq", body: "Body")
            XCTAssertNoThrow(try post.save())

            let config = Config(expiry: .seconds(3600), cacheDirectory: FileManager.default.currentDirectoryPath + "/SquirrelConnectorCache")
            SquirrelConnectorCache.setProjectionCache(name: "ProjectionCache", config: config)
            
            guard let res: proj = try Post.findOne() else {
                XCTFail()
                return
            }
            guard let tmp = try Post.findOne() else {
                XCTFail()
                return
            }
            XCTAssert(res._id == tmp._id)
            XCTAssert(res.title == tmp.title)
            XCTAssert(res._id == post._id)
            XCTAssert(res.title == post.title)

        } catch let error {
            XCTFail(String(describing: error))
        }
        SquirrelConnectorCache.clear()
        SquirrelConnectorCache.setProjectionCache(config: Config())
        SquirrelConnectorCache.clear()
    }

    func testEnumSaveFind() {
        guard Connector.setConnector(host: "localhost", dbname: "exampledb") else {
            XCTFail()
            return
        }
        XCTAssertNoThrow(try User.drop())
        var a = User(username: "Admin", role: .admin)
        XCTAssertNil(a._id)
        XCTAssertNoThrow(try a.save())
        XCTAssertNotNil(a._id)

        struct Role: Projectable {
            let role: User.Role
            init () {
                role = .user
            }
        }
        var b: Role? = nil
        XCTAssertNoThrow(b = try User.findOne("_id" == a._id!))

        guard let c = b else {
            XCTFail()
            return
        }

        XCTAssertEqual(c.role, a.role)
        var aa = User(username: "User", role: .user)
        XCTAssertNil(aa._id)
        XCTAssertNoThrow(try aa.save())
        XCTAssertNotNil(aa._id)

        var bb: Role? = nil
        XCTAssertNoThrow(bb = try User.findOne("_id" == aa._id!))

        guard let cc = bb else {
            XCTFail()
            return
        }

        XCTAssertEqual(cc.role, aa.role)

        XCTAssertNotEqual(cc.role, c.role)
        XCTAssertNotEqual(aa.role, a.role)
    }

    func testDistinct() {
        guard Connector.setConnector(host: "localhost", dbname: "exampledb") else {
            XCTFail()
            return
        }
        struct Car: Model {
            var _id: ObjectId? = nil
            let color: String
            let year: UInt
            init(color: String, year: UInt) {
                self.color = color
                self.year = year
            }
        }
        var models = [
            Car(color: "White", year: 1999),
            Car(color: "Red", year: 1993),
            Car(color: "Blue", year: 2000),
            Car(color: "Blue", year: 2004),
            Car(color: "Blue", year: 2010),
            Car(color: "Blue", year: 2007)
        ]
        guard (try? models.saveAllDocuments()) != nil else {
            XCTFail()
            return
        }

        let a: [String]
        let b: [String]
        do {
            a = try Car.distinct(on: "color")
            let bb = try Car.distinct(on: "color", filtering: "year" < 2000, resultType: String.self)
            b = bb
        } catch {
            XCTFail()
            return
        }
        XCTAssertEqual(Set(a), Set(["White", "Red", "Blue"]))
        XCTAssertEqual(Set(b), Set(["White", "Red"]))
    }

    static var allTests = [
        ("testSave", testSave),
        ("testMongoProjection", testMongoProjection),
        ("testEnumSaveFind", testEnumSaveFind),
        ("testDistinct", testDistinct)
        ]
}
