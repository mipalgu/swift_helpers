/*
 * Sequence.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 05/08/2017.
 * Copyright © 2017 Callum McColl. All rights reserved.
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

#if !NO_FOUNDATION
#if canImport(Foundation)
import Foundation
#endif
#endif

extension Collection where Self.SubSequence: Sequence, Self.SubSequence.Iterator.Element == Self.Iterator.Element {

    public func trim(
        _ shouldTrim: (Self.Iterator.Element) throws -> Bool
    ) rethrows -> Slice<ReversedRandomAccessCollection<ArraySlice<Self.Element>>> {
        let droppedReversed = try self.reversed().drop(while: shouldTrim)
        return try droppedReversed.reversed().drop(while: shouldTrim)
    }

}

extension Collection where
    Self.SubSequence: Sequence,
    Self.SubSequence.Iterator.Element == Self.Iterator.Element,
    Self.Iterator.Element: Equatable
{

    public func trim(
        _ element: Self.Iterator.Element
    ) -> Slice<ReversedRandomAccessCollection<ArraySlice<Self.Element>>> {
        return self.trim { $0 == element }
    }

}

extension Collection where
    Self.SubSequence: Sequence,
    Self.SubSequence.Iterator.Element == Self.Iterator.Element,
    Self.SubSequence.SubSequence: Sequence,
    Self.SubSequence.SubSequence.Iterator.Element == Self.Iterator.Element
{

    /**
     *  Reduce a sequence into a single value.
     *
     *  If the sequence is empty then `failSafe` is returned, if the
     *  sequence only contains 1 element then that element is returned,
     *  otherwise, the result of `transform` applied to all elements
     *  in order is returned.
     *
     *  This function is helpful, for example, when combining strings:
     *
     *  ```
     *  let data = ["first", "second", "third"]
     *  let result = data.combine("") { $0 + " " + $1 } // "first second third"
     *  ```
     *
     *  Use this function over reduce if you only want the transformation
     *  function to be applied to the elements, not the initial result:
     *
     *  ```
     *  let data = ["first", "second", "third"]
     *
     *  // Combine by placing a space between each element:
     *  let result = data.combine("") { $0 + " " + $1 } // "first second third"
     *
     *  // Common erroneous use of reduce:
     *  let result = data.reduce("") { $0 + " " + $1 } // " first second third" <- extra space prepended to first
     *
     *  // Correct handling using reduce:
     *  let result = data.dropFirst().reduce(data.first ?? "") { $0 + " " + $1 } // "first second third"
     *  ```
     *
     *  This function works with single element sequences:
     *  ```
     *  let data = ["first"]
     *
     *  // Combine by placing a space between each element:
     *  let result = data.combine("") { $0 + " " + $1 } // "first"
     *
     *  // Again, common erroneous use of reduce:
     *  let result = data.reduce("") { $0 + " " + $1 } // " first" <- extra space prepended to first
     *
     *  // Correct handling using reduce:
     *  let result = data.dropFirst().reduce(data.first ?? "") { $0 + " " + $1 } // "first"
     *  ```
     *
     *  The `failSafe` value is returned if the sequence is empty:
     *  ```
     *  let data: [String] = []
     *  let result = data.combine("") { $0 + " " + $1 } // ""
     *  ```
     *
     *  Often it is necessary to transform the elements in the sequence before
     *  combining them. This can be achieved in two steps:
     *
     *  ```
     *  let nums: [Int] = [1, 2, 3, 4]
     *
     *  // Converting the Int's to Strings before combining them:
     *  let result = nums.lazy.map { String($0) }.combine("") { $0 + " " + $1 } // "1 2 3 4"
     *
     *  // Equivalent functionality using reduce:
     *  let result = nums.dropFirst().reduce(nums.first.map { String($0) } ?? "") { $0 + " " + String($1) } // "1 2 3 4"
     *  ```
     *
     *  - Parameter failSafe: A value that is returned if the sequence is empty.
     *
     *  - Parameter transform: A function that combines two elements into a
     *  single element.
     *
     *  - Returns: A single element which is the result of combining all
     *  elements within the sequence into a single element.
     *
     *  - Complexity: O(n)
     *
     */
    public func combine(
        _ failSafe: Self.Iterator.Element,
        _ transform: (Self.Iterator.Element, Self.Iterator.Element) throws -> Self.Iterator.Element
    ) rethrows -> Self.Iterator.Element {
        guard let first = self.first(where: { _ in true }) else {
            return failSafe
        }
        guard let second = self.dropFirst().first(where: { _ in true }) else {
            return first
        }
        let firstResult = try transform(first, second)
        return try self.dropFirst().dropFirst().reduce(firstResult, transform)
    }

}

extension Sequence {

    public func failMap<T>(_ transform: (Self.Iterator.Element) throws -> T?) rethrows -> [T]? {
        var arr: [T] = []
        for e in self {
            guard let r = try transform(e) else {
                return nil
            }
            arr.append(r)
        }
        return arr
    }

}

extension Sequence {

    public func sortedCollection(
        _ compare: @escaping (Self.Iterator.Element, Self.Iterator.Element) -> ComparisonResult
    ) -> SortedCollection<Self.Iterator.Element> {
        return SortedCollection(unsortedSequence: self, comparator: AnyComparator(compare))
    }

}

extension Sequence where Self.Iterator.Element: Comparable {

    public func sortedCollection() -> SortedCollection<Self.Iterator.Element> {
        return SortedCollection(unsortedSequence: self)
    }

}

extension Collection where Self.SubSequence: Sequence, Self.SubSequence.Iterator.Element == Self.Iterator.Element {

    /**
     *  Split a sequence int sub-arrays where each sub-array contains elements
     *  that conform to `shouldGroup`.
     *
     *  In this example, `grouped(by:)` is used to group an `Array` of `Int`s:
     *  ````
     *      let numbers = [1, 1, 2, 2, 3, 4, 1, 1, 5]
     *      let grouped = numbers.grouped { $0 == $1 }
     *          // [[1, 1], [2, 2], [3], [4], [1, 1], [5]]
     *  ````
     *
     *  - Parameter shouldGroup: A function that returns true when two
     *    elements should be grouped together into a sub-array.
     */
    public func grouped(
        by shouldGroup: (Self.Iterator.Element, Self.Iterator.Element) throws -> Bool
    ) rethrows -> [[Self.Iterator.Element]] {
        guard let first = self.first(where: { _ in true }) else {
            return []
        }
        var groups: [[Self.Iterator.Element]] = [[first]]
        let _: Self.Iterator.Element = try self.dropFirst().reduce(first) {
            let result = try shouldGroup($0, $1)
            if false == result {
                groups.append([$1])
                return $1
            }
            groups[groups.endIndex - 1].append($1)
            return $1
        }
        return groups
    }

}

//swiftlint:disable opening_brace
extension Collection where
    Self.SubSequence: Sequence,
    Self.SubSequence.Iterator.Element == Self.Iterator.Element,
    Self.Iterator.Element: Equatable
{

    /**
     *  Split a sequence into sub-arrays where each sub-array contains elements
     *  that are equal.
     *
     *  In this example, `grouped()` is used to group an `Array` of `Int`s:
     *  ````
     *      let numbers = [1, 1, 2, 2, 3, 4, 1, 1, 5]
     *      let grouped = numbers.grouped()
     *          // [[1, 1], [2, 2], [3], [4], [1, 1], [5]]
     *  ````
     */
    public func grouped() -> [[Self.Iterator.Element]] {
        return self.grouped(by: ==)
    }

}

extension Sequence where Self: MutableCollection {
    
    public mutating func partialSort(limit: Int, _ compare: (Self.Iterator.Element, Self.Iterator.Element) -> Bool) {
        if self.isEmpty {
            return
        }
        func partition(start: Self.Index, end: Self.Index) -> Self.Index {
            let pivot = self[end]
            var i = start
            var j = start
            while j < end {
                if compare(self[j], pivot) {
                    self.swapAt(i, j)
                    i = self.index(after: i)
                }
                j = self.index(after: j)
            }
            self.swapAt(i, end)
            return i
        }
        func compute(start: Self.Index, end: Self.Index, targetIndex: Self.Index) {
            if start >= end {
                return
            }
            let p = partition(start: start, end: end)
            compute(start: start, end: self.index(p, offsetBy: -1), targetIndex: targetIndex)
            if p < self.index(targetIndex, offsetBy: -1) {
                compute(start: self.index(after: p), end: end, targetIndex: targetIndex)
            }
        }
        compute(
            start: self.startIndex,
            end: self.index(self.startIndex, offsetBy: self.count - 1),
            targetIndex: self.index(self.startIndex, offsetBy: limit)
        )
    }
    
    public func partialSorted(limit: Int, _ compare: (Self.Iterator.Element, Self.Iterator.Element) -> Bool) -> Self {
        var copy = self
        copy.partialSort(limit: limit, compare)
        return copy
    }
    
}

extension Sequence where Self: MutableCollection, Self.Iterator.Element: Comparable {
    
    public mutating func partialSort(limit: Int) {
        self.partialSort(limit: limit, <)
    }
    
    public func partialSorted(limit: Int) -> Self {
        return self.partialSorted(limit: limit, <)
    }
    
}
