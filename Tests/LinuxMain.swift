import XCTest
@testable import swift_helpersTests
@testable import HashingTests

XCTMain([
    testCase(StringHelpersTests.allTests)
    testCase(HashSinkTests.allTests)
    testCase(HashTableTests.allTests)
])
