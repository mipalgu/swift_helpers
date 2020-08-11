/*
 * SequenceTests.swift 
 * swift_helpersTests 
 *
 * Created by Callum McColl on 05/02/2019.
 * Copyright © 2019 Callum McColl. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials
 *    provided with the distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgement:
 *
 *        This product includes software developed by Callum McColl.
 *
 * 4. Neither the name of the author nor the names of contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * -----------------------------------------------------------------------
 * This program is free software; you can redistribute it and/or
 * modify it under the above terms or under the terms of the GNU
 * General Public License as published by the Free Software Foundation;
 * either version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see http://www.gnu.org/licenses/
 * or write to the Free Software Foundation, Inc., 51 Franklin Street,
 * Fifth Floor, Boston, MA  02110-1301, USA.
 *
 */

@testable import swift_helpers
import XCTest

public class SequenceTests: XCTestCase {

    private static let bigArr: [Int] = Array(0..<10000).shuffled()
    
    public static var allTests: [(String, (SequenceTests) -> () throws -> Void)] {
        return [
            ("test_binarySearchReturnsNoElementsWhenNoneAreFound", test_binarySearchReturnsNoElementsWhenNoneAreFound),
            ("test_binarySearchReturnsElementInTheMiddle", test_binarySearchReturnsElementInTheMiddle),
            ("test_binarySearchReturnsSingleElements", test_binarySearchReturnsSingleElements),
            ("test_binarySearchReturnsAllElementsAtTheFront", test_binarySearchReturnsAllElementsAtTheFront),
            ("test_binarySearchReturnsAllElementsAtTheEnd", test_binarySearchReturnsAllElementsAtTheEnd),
            ("test_binarySearchReturnsTheEntireCollection", test_binarySearchReturnsTheEntireCollection),
            ("test_binarySearchReturnsEmptyCollection", test_binarySearchReturnsEmptyCollection),
            ("test_insertingIntoSortedCollection", test_insertingIntoSortedCollection),
            ("test_performance", test_performance),
            ("test_filterPerformance", test_filterPerformance),
            ("test_performanceMissing", test_performanceMissing),
            ("test_filterPerformanceMissing", test_filterPerformanceMissing)
        ]
    }
    
    fileprivate func createArray(count: Int) -> [Int] {
        let ones = Array(repeating: 1, count: count)
        let twos = Array(repeating: 2, count: count)
        let threes = Array(repeating: 3, count: count)
        let fours = Array(repeating: 4, count: count)
        let fives = Array(repeating: 5, count: count)
        let arr = threes + fours + fives + twos + ones
        return arr
    }

    fileprivate func createSortedCollection(count: Int) -> SortedCollection<Int> {
        let ones = Array(repeating: 1, count: count)
        let twos = Array(repeating: 2, count: count)
        let threes = Array(repeating: 3, count: count)
        let fours = Array(repeating: 4, count: count)
        let fives = Array(repeating: 5, count: count)
        return SortedCollection(sortedArray: ones + twos + threes + fours + fives)
    }

    public func test_binarySearchReturnsNoElementsWhenNoneAreFound() {
        let arr: SortedCollection<Int> = [1, 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 5]
        let results = arr.find(0)
        XCTAssertEqual([], Array(results))
    }

    public func test_binarySearchReturnsElementInTheMiddle() {
        let arr: SortedCollection<Int> = [1, 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 5]
        let results = arr.find(3)
        XCTAssertEqual([3, 3], Array(results))
    }

    public func test_binarySearchReturnsSingleElements() {
        let arr: SortedCollection<Int> = [1, 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 5]
        let results2 = arr.find(2)
        XCTAssertEqual([2], Array(results2))
        let results4 = arr.find(4)
        XCTAssertEqual([4], Array(results4))
    }

    public func test_binarySearchReturnsAllElementsAtTheFront() {
        let arr: SortedCollection<Int> = [1, 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 5]
        let results = arr.find(1)
        XCTAssertEqual([1, 1, 1, 1], Array(results))
    }

    public func test_binarySearchReturnsAllElementsAtTheEnd() {
        let arr: SortedCollection<Int> = [1, 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 5]
        let results = arr.find(5)
        XCTAssertEqual([5, 5, 5, 5, 5], Array(results))
    }

    public func test_binarySearchReturnsTheEntireCollection() {
        let arr: SortedCollection<Int> = [1, 1, 1, 1]
        let results = arr.find(1)
        XCTAssertEqual([1, 1, 1, 1], Array(results))
    }

    public func test_binarySearchReturnsEmptyCollection() {
        let arr: SortedCollection<Int> = []
        let results = arr.find(0)
        XCTAssertEqual([], Array(results))
    }

    public func test_insertingIntoSortedCollection() {
        var collection: SortedCollection<Int> = []
        XCTAssertEqual([], Array(collection))
        collection.insert(1)
        XCTAssertEqual([1], Array(collection))
        collection.insert(2)
        XCTAssertEqual([1, 2], Array(collection))
        collection.insert(2)
        XCTAssertEqual([1, 2, 2], Array(collection))
        collection.insert(0)
        XCTAssertEqual([0, 1, 2, 2], Array(collection))
        collection.insert(-1)
        XCTAssertEqual([-1, 0, 1, 2, 2], Array(collection))
    }

    public func test_performance() {
        let arr = self.createSortedCollection(count: 100000)
        measure {
            _ = arr.find(1)
            _ = arr.find(2)
            _ = arr.find(3)
            _ = arr.find(4)
            _ = arr.find(5)
        }
    }

    public func test_filterPerformance() {
        let arr = self.createSortedCollection(count: 100000)
        measure {
            _ = arr.filter { $0 == 1 }
            _ = arr.filter { $0 == 2 }
            _ = arr.filter { $0 == 3 }
            _ = arr.filter { $0 == 4 }
            _ = arr.filter { $0 == 5 }
        }
    }

    public func test_performanceMissing() {
        let arr = self.createSortedCollection(count: 1000000)
        measure {
            _ = arr.find(0)
        }
    }

    public func test_filterPerformanceMissing() {
        let arr = self.createSortedCollection(count: 1000000)
        measure {
            _ = arr.filter { $0 == 0 }
        }
    }
    
    public func test_partialSort() {
        let limit = 3
        let arr = [5, 4, 3, 2, 1, 10, 12, 123, 10, 11, 12, 13, 14, 15, 16, 17, 18, -5, -1, -7]
        let result = arr.sorted(limit: limit)
        XCTAssertEqual(Array(result[..<limit]), [-7, -5, -1])
    }
    
    public func test_partialSortPerformance() {
        let limit = 3
        var arr = Self.bigArr
        measure {
            arr.sort(limit: limit)
            _ = arr[..<limit]
        }
    }
    
    public func test_partialSortUsingSortPerformance() {
        let limit = 3
        var arr = Self.bigArr
        measure {
            arr.sort()
            _ = arr[..<limit]
        }
    }

}
