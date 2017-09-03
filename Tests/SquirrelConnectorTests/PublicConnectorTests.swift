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

class PublicConnectorTests: XCTestCase {
    func testSave() {
        let dbata = ["id": "59984722610934e182846e7b"]
        let jsonDecoder = JSONDecoder()
        let jsonData = try! JSONSerialization.data(withJSONObject: dbata)
        XCTAssertNoThrow(_ = try! jsonDecoder.decode(ObjectId.self, from: jsonData))

        Connector.setConnector(host: "localhost", dbname: "exampledb")
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
            Connector.setConnector(host: "localhost")
            XCTAssertNoThrow(try Post.drop())
            var post = Post(title: "Titliq", body: "Body")
            XCTAssertNoThrow(try post.save())

            let config = Config(expiry: .seconds(3600), cacheDirectory: FileManager.default.currentDirectoryPath + "/SquirrelConnectorCache")
            SquirrelConnectorCache.setProjectionCache(specializedCache: SpecializedCache(name: "ProjectionCache", config: config))
            
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
        SquirrelConnectorCache.setProjectionCache(specializedCache: SpecializedCache(name: "ProjectionCache"))
        SquirrelConnectorCache.clear()
    }

    static var allTests = [
        ("testSave", testSave),
        ("testMongoProjection", testMongoProjection),
        ]
}
