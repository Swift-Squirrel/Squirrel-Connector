import XCTest
@testable import SquirrelConnector

struct Comment: Codable {
    let user: ObjectId
    let comment: String
}

struct Post: Model {
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }

    var id: ObjectId? = nil
    var cmnt = Comment(user: try! ObjectId("59984722610934e182846e7b"), comment: "commment")
    var title: String = ""
    var body: String = ""
    var comments: [Comment] = []
    var created = Date()
    var modified = Date()
}

class SquirrelConnectorTests: XCTestCase {
    func testExample() {
        guard Connector.setConnector(host: "localhost", dbname: "exampledb") else {
            XCTFail()
            return
        }
        XCTAssertNoThrow(try Post.drop())
        var a = Post(title: "Dogs", body: "Dogs are not dogs!")
        a.comments = [
            Comment(user: try! ObjectId("59984722610934e182846e7b"), comment: "blah"),
            Comment(user: try! ObjectId("59984722610934e182846e7e"), comment: "blah blach")
        ]
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

    func testFindBasic() {
        guard Connector.setConnector(host: "localhost", dbname: "exampledb") else {
            XCTFail()
            return
        }
        var a = Post(title: "Dogs", body: "Dogs are not cats!")
        a.comments.append(Comment(user: try! ObjectId("59984722610934e182846e7b"), comment: "blah"))
        XCTAssertNoThrow(try Post.drop())
        XCTAssertNoThrow(try a.save())
        var b = try! Post.find()
        XCTAssertNotNil(b.first)
        XCTAssert(b.first!.id! == a.id!)
        let encoder = JSONEncoder()
        let data = try! encoder.encode(b)
        let str = String(data: data, encoding: .utf8)!
        XCTAssert(str == b.json)

        let c = try! Post.findOne()
        XCTAssertNotNil(c)
        if let cc = c {
            XCTAssert(cc.id == a.id)
            XCTAssert(cc.title == a.title)
        } else {
            XCTFail()
        }

        XCTAssertNoThrow(try b.removeAllDocuments())
        XCTAssert(b.first!.id == nil)
    }

    func testProjection() {
        struct TitleBody: Projectable {
            var title: String = ""
            var body: String = ""
        }
        guard Connector.setConnector(host: "localhost", dbname: "exampledb") else {
            XCTFail()
            return
        }
        var a = Post(title: "Dogs", body: "Dogs are not cats!")
        a.comments.append(Comment(user: try! ObjectId("59984722610934e182846e7b"), comment: "blah"))
        XCTAssertNoThrow(try Post.drop())
        XCTAssertNoThrow(try a.save())
        let b: [TitleBody] = try! Post.find()
        XCTAssertNotNil(b.first)
        let frst = b.first!
        XCTAssert(frst.body == a.body)
        XCTAssert(frst.title == a.title)

        let c: TitleBody? = try! Post.findOne()
        XCTAssertNotNil(c)
        if let cc = c {
            XCTAssert(cc.body == a.body)
            XCTAssert(cc.title == a.title)
        } else {
            XCTFail()
        }
    }

    func testDate() {
        struct Created: Projectable {
            let created: Date = Date()
        }
        guard Connector.setConnector(host: "localhost", dbname: "exampledb") else {
            XCTFail()
            return
        }
        var a = Post(title: "Dogs", body: "Dogs are not cats!")
        XCTAssertNoThrow(try Post.drop())
        XCTAssertNoThrow(try a.save())

        guard let b: Created = try! Post.findOne() else {
            XCTFail()
            return
        }

        XCTAssert(Int64(a.created.timeIntervalSince1970) == Int64(b.created.timeIntervalSince1970))
        XCTAssert(a.created.description(with: .current) == b.created.description(with: .current))

        XCTAssertNoThrow(try Post.drop())
    }

    static var allTests = [
        ("testExample", testExample),
        ("testFindBasic", testFindBasic),
        ("testProjection", testProjection),
        ("testDate", testDate)
    ]
}

