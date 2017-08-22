import XCTest
@testable import SquirrelConnectorTests

XCTMain([
    testCase(SquirrelConnectorTests.allTests),
    testCase(PublicConnectorTests.allTests)
])
