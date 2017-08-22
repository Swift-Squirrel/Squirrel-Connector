# Squirrel-Connector
Squirrel ORM connector for mongodb

## Requirements
Mongodb 3.4

## Usage

```swift
import SquirrelConnector
```

### Set connector

```swift
Connector.setConnector(host: String, port: Int = 27017, dbname: String = "squirrel")
// or
Connector.setConnector(username: String, password: String,
                       host: String, port: Int = 27017, dbname: String = "squirrel") 
```

### Model interface

```swift
extension Model {
    static func find<T>(_ filter: Query? = nil, sortedBy sort: Sort? = nil, 
        collation: Collation? = nil, skipping skip: Int? = nil, limitedTo limit: Int? = nil)
        throws -> [T] where T: Codable
        
    static func findOne<T>(_ filter: Query? = nil, sortedBy sort: Sort? = nil,
          collation: Collation? = nil, skipping skip: Int? = nil) 
          throws -> T? where T: Codable
    
    static var collection: MongoKitten.Collection { get }
    
    static func create() throws
    
    static func drop() throws
    
    var json: String { get }
    
    mutating func save() throws
    
    mutating func remove() throws
}

extension Array where Element : Model {
    var json: String { get }
    
    mutating func saveAllDocuments() throws
    
    mutating func removeAllDocuments() throws
}
```

### Model
We want to store post with comments. Our post have to conform to `Model` protocol and all structures used in `Post` have to conform to `Codable`

```swift
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
    var title: String
    var body: String
    var comments: [Comment] = []
}
```

### Model examples

```swift
// set connector
Connector.setConnector(host: "localhost", dbname: "exampledb")

var post = Post(title: "Dogs", body: "Dogs are not cats!")
post.comments.append(Comment(user: try! ObjectId("59984722610934e182846e7b"), comment: "blah"))

try Post.drop() // remove all posts from database
try post.save() // save Dogs post to database

let postsFromDatabase = try Post.find("title" == "Dogs") // returns [Post] where title is "Dogs"

struct Title: Codable {
    var title: String
}

let titlesFromDatabase: [Title] = try Post.find() // returns only titles
```

## See Also
- MongoKitten (https://github.com/OpenKitten/MongoKitten)

## Installation

swift 4

```swift
.package(url: "https://github.com/LeoNavel/Squirrel-Connector.git", from: "0.1.0"),
```

don't forget to run in console:

```
swift package edit CryptoSwift --revision swift4
```

it's because of we are using third party libraries which are not in swift4 by default




