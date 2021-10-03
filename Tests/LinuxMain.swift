import XCTest
@testable import swift_helpersTests
@testable import HashingTests
@testable import IOTests

XCTMain([
    testCase(FileWrapperTests.allTests),
    testCase(SequenceTests.allTests),
    testCase(StringHelpersTests.allTests),
    testCase(HashSinkTests.allTests),
    testCase(HashTableTests.allTests)
])
