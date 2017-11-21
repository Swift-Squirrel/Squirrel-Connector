//
//  PublicConnectorTests.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/19/17.
//
//

import XCTest
import SquirrelConnector
import Cache

class User: Model {
    var id: ObjectId? = nil
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
        XCTAssertNil(a.id)
        XCTAssertNoThrow(try a.save())
        XCTAssertNotNil(a.id)
        let id = a.id
        a.body = "Dogs are not cats!"
        XCTAssertNotNil(a.id)
        XCTAssertNoThrow(try a.save())
        XCTAssertNotNil(a.id)
        XCTAssertTrue(id == a.id)
    }

    func testMongoProjection() {
        do {
            struct proj: Projectable {
                let id: ObjectId?
                let title: String

                init() {
                    id = nil
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
            XCTAssert(res.id == tmp.id)
            XCTAssert(res.title == tmp.title)
            XCTAssert(res.id == post.id)
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
        XCTAssertNil(a.id)
        XCTAssertNoThrow(try a.save())
        XCTAssertNotNil(a.id)

        struct Role: Projectable {
            let role: User.Role
            init () {
                role = .user
            }
        }
        var b: Role? = nil
        XCTAssertNoThrow(b = try User.findOne("_id" == a.id!))

        guard let c = b else {
            XCTFail()
            return
        }

        XCTAssertEqual(c.role, a.role)
        var aa = User(username: "User", role: .user)
        XCTAssertNil(aa.id)
        XCTAssertNoThrow(try aa.save())
        XCTAssertNotNil(aa.id)

        var bb: Role? = nil
        XCTAssertNoThrow(bb = try User.findOne("_id" == aa.id!))

        guard let cc = bb else {
            XCTFail()
            return
        }

        XCTAssertEqual(cc.role, aa.role)

        XCTAssertNotEqual(cc.role, c.role)
        XCTAssertNotEqual(aa.role, a.role)
    }

    static var allTests = [
        ("testSave", testSave),
        ("testMongoProjection", testMongoProjection),
        ("testEnumSaveFind", testEnumSaveFind),
        ]
}
