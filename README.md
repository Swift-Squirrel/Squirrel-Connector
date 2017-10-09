# Squirrel-Connector

[![CircleCI](https://img.shields.io/circleci/project/github/RedSparr0w/node-csgo-parser.svg)](https://circleci.com/gh/LeoNavel/Squirrel-Connector)
[![platform](https://img.shields.io/badge/Platforms-OS_X%20%7C_Linux-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![SPM](https://img.shields.io/badge/spm-Compatible-brightgreen.svg)](https://swift.org)
[![swift](https://img.shields.io/badge/swift-4.0-orange.svg)](https://developer.apple.com/swift/)

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
        throws -> [T] where T: Presentable
        
    static func findOne<T>(_ filter: Query? = nil, sortedBy sort: Sort? = nil,
          collation: Collation? = nil, skipping skip: Int? = nil) 
          throws -> T? where T: Presentable
    
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

### Presentable
Presentable struct can be used as expected projection as result of `find` method

```swift
public protocol Presentable {
    init()
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

struct Title: Presentable {
    var title: String
}

let titlesFromDatabase: [Title] = try Post.find() // returns only titles
```

### Cache
Squirrel Connector uses caches to store `Projection` of `Presentable` object

```swift
public struct SquirrelConnectorCache {

    /// Default name for cache
    public static let defaultName = "ProjectionCache"

    /// Set projection cache manager
    ///
    /// - Parameters:
    ///   - name: name of cache folder
    ///   - config: Configuration
    public static func setProjectionCache(name: String = defaultName, config: Config) {

    /// Total disk size
    public static var totalDiskSize: UInt64 { get }

    /// Name of cache
    public static var name: String { get }

    /// Path of cache directory
    public static var path: String { get }

    /// Clears the front and back cache storages.
    ///
    /// - Parameter keepRoot: Pass `true` to keep the existing disk cache directory
    /// after removing its contents. The default value is `false`.
    public static func clear(keepingRootDirectory keepRoot: Bool = false)

    /// Clears all expired objects from front and back storages.
    public static func clearExpired()
}
```

## See Also
- [MongoKitten](https://github.com/OpenKitten/MongoKitten) Native MongoDB driver for Swift, written in Swift 
- [Cache](https://github.com/LeoNavel/Cache) 📦 Nothing but Cache. 

## Installation

swift 4

```swift
.package(url: "https://github.com/Swift-Squirrel/Squirrel-Connector.git", from: "0.1.5"),
```

