/*
 * SortedCollectionSlice.swift 
 * swift_helpers 
 *
 * Created by Callum McColl on 08/02/2019.
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

#if !NO_FOUNDATION
#if canImport(Foundation)
import Foundation
#endif
#endif

public struct SortedCollectionSlice<Element>: ComparatorContainer {

    public let comparator: AnyComparator<Element>

    fileprivate var data: Array<Element>.SubSequence

    internal init(data: Array<Element>.SubSequence, comparator: AnyComparator<Element>) {
        self.data = data
        self.comparator = comparator
    }

    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        self.data.reserveCapacity(minimumCapacity)
    }

}

extension SortedCollectionSlice: Sequence {

    public func makeIterator() -> Array<Element>.SubSequence.Iterator {
        return self.data.makeIterator()
    }

}

extension SortedCollectionSlice: RandomAccessCollection {

    public var count: Int {
        return self.data.count
    }

    public var endIndex: Array<Element>.SubSequence.Index {
        return self.data.endIndex
    }

    public var first: Element? {
        return self.data.first
    }

    public var indices: Array<Element>.SubSequence.Indices {
        return self.data.indices
    }

    public var startIndex: Array<Element>.SubSequence.Index {
        return self.data.startIndex
    }

    public subscript(position: Array<Element>.SubSequence.Index) -> Element {
        return self.data[position]
    }

    public func index(after i: Array<Element>.SubSequence.Index) -> Array<Element>.SubSequence.Index {
        return self.data.index(after: i)
    }

    public func index(before i: Array<Element>.SubSequence.Index) -> Array<Element>.SubSequence.Index {
        return self.data.index(before: i)
    }

    public subscript(bounds: Range<Array<Element>.SubSequence.Index>) -> SortedCollectionSlice<Element> {
        return SortedCollectionSlice(data: self.data[bounds], comparator: self.comparator)
    }

}

extension SortedCollectionSlice: SortedOperations {

    public mutating func empty() {
        self.data = []
    }

    public mutating func insert(_ element: Element) {
        self.data.insert(element, at: self.search(for: element).1)
    }

    public mutating func remove(at index: Array<Element>.SubSequence.Index) -> Element {
        return self.data.remove(at: index)
    }

    public mutating func removeSubrange(_ bounds: Range<Array<Element>.SubSequence.Index>) {
        self.data.removeSubrange(bounds)
    }

}

extension SortedCollectionSlice: Equatable where Element: Equatable {

    public static func == (lhs: SortedCollectionSlice<Element>, rhs: SortedCollectionSlice<Element>) -> Bool {
        return lhs.data == rhs.data
    }

}

extension SortedCollectionSlice: Hashable where Element: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.data)
    }

}
