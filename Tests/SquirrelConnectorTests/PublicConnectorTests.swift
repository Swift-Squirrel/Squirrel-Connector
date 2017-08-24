//
//  PublicConnectorTests.swift
//  SquirrelConnector
//
//  Created by Filip Klembara on 8/19/17.
//
//

import XCTest
import SquirrelConnector

class PublicConnectorTests: XCTestCase {
    func testSave() {
        let dbata = ["id": "59984722610934e182846e7b"]
        let jsonDecoder = JSONDecoder()
        let jsonData = try! JSONSerialization.data(withJSONObject: dbata)
        XCTAssertNoThrow(_ = try! jsonDecoder.decode(ObjectId.self, from: jsonData))

        Connector.setConnector(host: "localhost", dbname: "exampledb")
        XCTAssertNoThrow(try Post.drop())
        var a = Post(title: "Dogs", body: "Dogs are not dogs!")
//        a.comments = [
//            Comment(user: try! ObjectId("59984722610934e182846e7b"), comment: "blah"),
//            Comment(user: try! ObjectId("59984722610934e182846e7e"), comment: "blah blach")
//        ]
        XCTAssertNil(a.id)
        XCTAssertNoThrow(try a.save())
        XCTAssertNotNil(a.id)
        let id = a.id
        a.body = "Dogs are not cats!"
//        a.comments.append(Comment(user: try! ObjectId("59984722610934e182846e7b"), comment: "nah"))
        XCTAssertNotNil(a.id)
        XCTAssertNoThrow(try a.save())
        XCTAssertNotNil(a.id)
        XCTAssertTrue(id == a.id)
    }

    static var allTests = [
        ("testExample", testSave),
        ]
}
