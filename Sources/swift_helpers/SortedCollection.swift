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

public struct SortedCollection<Element>: UnderlyingDataContainer, ComparatorContainer {
    
    public let comparator: AnyComparator<Element>
    public var data: [Element]
    
    public init(comparator: AnyComparator<Element>) {
        self.init(unsortedSequence: [], comparator: comparator)
    }
    
    public init<S: Sequence>(unsortedSequence: S, comparator: AnyComparator<Element>) where S.Element == Element {
        self.init(
            sortedArray: unsortedSequence.sorted {
                switch comparator.compare(lhs: $0, rhs: $1) {
                case .orderedAscending:
                    return true
                default:
                    return false
                }
            },
            comparator: comparator
        )
    }
    
    public init(sortedArray: [Element], comparator: AnyComparator<Element>) {
        self.data = sortedArray
        self.comparator = comparator
    }
    
}

extension SortedCollection where Element: Comparable {
    
    public init<S: Sequence>(unsortedSequence: S) where S.Element == Element {
        self.init(sortedArray: unsortedSequence.sorted())
    }
    
    public init(sortedArray: [Element]) {
        self.init(
            sortedArray: sortedArray,
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

extension SortedCollection: BidirectionalCollection, RandomAccessCollection {
    
    public typealias Buffer = Array<Element>
    public typealias Index = Buffer.Index
    public typealias Indices = Buffer.Indices
    public typealias Iterator = Buffer.Iterator
    public typealias IndexDistance = Int
    public typealias SubSequence = SortedCollectionSlice<Element>
    
    public func index(after i: Index) -> Index {
        return self.data.index(after: i)
    }
    
    public func index(before i: Index) -> Index {
        return self.data.index(before: i)
    }
    
    public subscript(bounds: Range<Index>) -> SortedCollectionSlice<Element> {
        return SortedCollectionSlice(data: self.data[bounds], comparator: self.comparator)
    }
    
}

extension SortedCollection: SortedOperations {}

extension SortedCollection: Equatable where Element: Equatable {}

extension SortedCollection: Hashable where Element: Hashable {}
