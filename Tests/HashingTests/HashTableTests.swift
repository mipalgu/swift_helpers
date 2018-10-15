/*
 * HashTableTests.swift 
 * HashingTests 
 *
 * Created by Callum McColl on 15/10/2018.
 * Copyright © 2018 Callum McColl. All rights reserved.
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

@testable import Hashing
import XCTest

public class HashTableTests: XCTestCase {

    public static var allTests: [(String, (HashTableTests) -> () throws -> Void)] {
        return [
            ("test_tableInsertsElements", test_tableInsertsElements),
            ("test_tableContainsElement", test_tableContainsElement),
            ("test_DoesntInsertSameElementTwice", test_DoesntInsertSameElementTwice),
            ("test_Sequence", test_Sequence)
        ]
    }

    fileprivate var table: HashTable<Point2D> = HashTable()

    public override func setUp() {
        self.table = HashTable()
    }

    public func test_tableInsertsElements() {
        let point1 = Point2D(x: 1, y: 2)
        let point2 = Point2D(x: 2, y: 3)
        self.table.insert(point1)
        self.table.insert(point2)
        XCTAssertEqual(self.table.count, 2)
    }

    public func test_tableContainsElement() {
        let point1 = Point2D(x: 1, y: 2)
        XCTAssertFalse(self.table.contains(point1))
        self.table.insert(point1)
        XCTAssertTrue(self.table.contains(point1))
    }

    public func test_DoesntInsertSameElementTwice() {
        let point1 = Point2D(x: 1, y: 2)
        XCTAssertEqual(self.table.count, 0)
        self.table.insert(point1)
        XCTAssertEqual(self.table.count, 1)
        XCTAssertTrue(self.table.contains(point1))
        self.table.insert(point1)
        XCTAssertEqual(self.table.count, 1)
        XCTAssertTrue(self.table.contains(point1))
    }

    public func test_Sequence() {
        let point1 = Point2D(x: 1, y: 2)
        let point2 = Point2D(x: 2, y: 3)
        self.table.insert(point1)
        self.table.insert(point2)
        let expected = [point1, point2]
        compare(self.table.map { $0 }, expected)
        var arr: [Point2D] = []
        for element in self.table {
            arr.append(element)
        }
        compare(arr, expected)
    }

    fileprivate func compare(_ lhs: [Point2D], _ rhs: [Point2D]) {
        XCTAssertEqual(lhs.count, rhs.count)
        let sorted = lhs.sorted { $0.x == $1.x ? $0.y < $1.y : $0.x < $1.x }
        zip(sorted, rhs).forEach {
            XCTAssertEqual($0, $1)
        }
    }

}
