// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SquirrelConnector",
    products: [
        .library(
            name: "SquirrelConnector",
            targets: ["SquirrelConnector"]),
    ],
    dependencies: [
        .package(url: "https://github.com/OpenKitten/MongoKitten.git", from: "4.0.13"),
        .package(url: "https://github.com/Swift-Squirrel/SquirrelJSON.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "SquirrelConnector",
            dependencies: ["MongoKitten", "SquirrelJSON"]),
        .testTarget(
            name: "SquirrelConnectorTests",
            dependencies: ["SquirrelConnector"]),       
    ]
)
