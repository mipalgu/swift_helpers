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

public struct SortedCollection<Element> {
    
    fileprivate let comparator: AnyComparator<Element>
    fileprivate var data: [Element]
    
    public init(comparator: AnyComparator<Element>) {
        self.init(unsortedSequence: [], comparator: comparator)
    }
    
    public init<S: Sequence>(unsortedSequence: S, comparator: AnyComparator<Element>) where S.Element == Element {
        self.data = unsortedSequence.sorted {
            switch comparator.compare(lhs: $0, rhs: $1) {
            case .orderedAscending:
                return true
            default:
                return false
            }
        }
        self.comparator = comparator
    }
    
}

extension SortedCollection where Element: Comparable {
    
    public init<S: Sequence>(unsortedSequence: S) where S.Element == Element {
        self.init(
            unsortedSequence: unsortedSequence,
            comparator: AnyComparator {
                if $0 < $1 {
                    return .orderedAscending
                }
                if $0 > $1 {
                    return .orderedDescending
                }
                return .orderedSame
            }
        )
    }
    
    public init() {
        self.init(unsortedSequence: [])
    }
    
    public init(minimumCapacity: Int) {
        self.init()
        self.data.reserveCapacity(minimumCapacity)
    }
    
}

extension SortedCollection: ExpressibleByArrayLiteral where Element: Comparable {
    
    public typealias ArrayLiteralElement = Element
    
    public init(arrayLiteral elements: Element...) {
        self.init(unsortedSequence: elements)
    }
    
}

extension SortedCollection: Sequence {
    
    public func makeIterator() -> Array<Element>.Iterator {
        return self.data.makeIterator()
    }
    
}

extension SortedCollection: Collection {
    
    public var count: Int {
        return self.data.count
    }
    
    public var endIndex: Array<Element>.Index {
        return self.data.endIndex
    }
    
    public var first: Element? {
        return self.data.first
    }
    
    public var indices: Array<Element>.Indices {
        return self.data.indices
    }
    
    public var startIndex: Array<Element>.Index {
        return self.data.startIndex
    }
    
    public subscript(position: Array<Element>.Index) -> Element {
        return self.data[position]
    }
    
    public func index(after i: Array<Element>.Index) -> Array<Element>.Index {
        return self.data.index(after: i)
    }
    
}

extension SortedCollection: BidirectionalCollection {
    
    public func index(before i: Array<Element>.Index) -> Array<Element>.Index {
        return self.data.index(before: i)
    }
    
}

extension SortedCollection: RandomAccessCollection {
    
    public subscript(bounds: Range<Array<Element>.Index>) -> Array<Element>.SubSequence {
        return self.data[bounds]
    }
    
}

extension SortedCollection: SortedOperations {
    
    public func anyLocation(of element: Element) -> Array<Element>.Index {
        let index = self.insertIndex(for: element)
        if index == self.endIndex {
            return index
        }
        switch self.comparator.compare(lhs: self[index], rhs: element) {
        case .orderedSame:
            return index
        default:
            return self.endIndex
        }
    }
    
    public func contains(_ element: Element) -> Bool {
        return self.anyLocation(of: element) != self.endIndex
    }
    
    public func range(of element: Element) -> Range<Array<Element>.Index> {
        let index = self.anyLocation(of: element)
        if index == self.endIndex {
            return self.endIndex ..< self.endIndex
        }
        let startIndex = self[self.startIndex ..< index].reversed().firstIndex { self.comparator.compare(lhs: $0, rhs: element).rawValue != 0 }?.base ?? self.startIndex
        let endIndex = self[self.index(after: index) ..< self.endIndex].firstIndex { self.comparator.compare(lhs: $0, rhs: element).rawValue != 0 } ?? self.endIndex
        return startIndex ..< endIndex
    }
    
    public func firstLocation(of element: Element) -> Array<Element>.Index? {
        let index = self.anyLocation(of: element)
        if index == self.endIndex {
            return nil
        }
        return self[self.startIndex ..< index].reversed().firstIndex { self.comparator.compare(lhs: $0, rhs: element).rawValue != 0 }?.base ?? self.startIndex
    }
    
    public func lastLocation(of element: Element) -> Array<Element>.Index? {
        let index = self.anyLocation(of: element)
        if index == self.endIndex {
            return nil
        }
        return self[self.index(after: index) ..< self.endIndex].firstIndex { self.comparator.compare(lhs: $0, rhs: element).rawValue != 0 } ?? self.endIndex
    }
    
    public func insertIndex(for element: Element) -> Array<Element>.Index {
        var lower = 0
        var upper = self.count - 1
        while lower <= upper {
            let offset = (lower + upper) / 2
            let currentIndex = self.index(self.startIndex, offsetBy: offset)
            switch self.comparator.compare(lhs: self[currentIndex], rhs: element) {
            case .orderedSame:
                return currentIndex
            case .orderedDescending:
                upper = offset - 1
            case .orderedAscending:
                lower = offset + 1
            }
        }
        return self.index(self.startIndex, offsetBy: lower)
    }
    
    public mutating func insert(_ element: Element) {
        let index = self.insertIndex(for: element)
        if index == self.endIndex {
            self.data.append(element)
            return
        }
        self.data.insert(element, at: index)
    }
    
}

extension SortedCollection: Equatable where Element: Equatable {
    
    public static func == (lhs: SortedCollection<Element>, rhs: SortedCollection<Element>) -> Bool {
        return lhs.data == rhs.data
    }
    
}

extension SortedCollection: Hashable where Element: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.data)
    }
    
}
