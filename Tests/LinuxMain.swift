import XCTest
@testable import swift_helpersTests
@testable import HashingTests

XCTMain([
    testCase(SequenceTests.allTests),
    testCase(StringHelpersTests.allTests),
    testCase(HashSinkTests.allTests),
    testCase(HashTableTests.allTests)
])
