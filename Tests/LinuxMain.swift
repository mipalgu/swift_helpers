import XCTest
@testable import swift_helpersTests
@testable import HashingTests
@testable import IOTests

XCTMain([
    testCase(SequenceTests.allTests),
    testCase(StringHelpersTests.allTests),
    testCase(HashSinkTests.allTests),
    testCase(HashTableTests.allTests),
    testCase(FileWrapperTests.allTests)
])
