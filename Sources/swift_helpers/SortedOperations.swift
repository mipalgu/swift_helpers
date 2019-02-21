/*
 * SortedOperations.swift 
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

public protocol SortedOperations: RandomAccessCollection {
    
    func anyIndex(of: Element) -> Index?
    
    func count(of: Element) -> Int
    
    func count(leftOf: Element) -> Int
    
    func count(rightOf: Element) -> Int
    
    func count(leftOfAndIncluding: Element) -> Int
    
    func count(rightOfAndIncluding: Element) -> Int
    
    func contains(_ element: Element) -> Bool
    
    func range(of: Element) -> Range<Index>
    
    func firstIndex(of: Element) -> Index?
    
    func lastIndex(of: Element) -> Index?
    
    func search(for: Element) -> (Bool, Index)
    
    func find(_: Element) -> Self.SubSequence
    
    func left(of: Element) -> Self.SubSequence
    
    func left(ofAndIncluding: Element) -> Self.SubSequence
    
    func right(of: Element) -> Self.SubSequence
    
    func right(ofAndIncluding: Element) -> Self.SubSequence
    
    mutating func insert(_: Element)
    
    mutating func remove(at: Self.Index) -> Element
    
    mutating func removeSubrange(_: Range<Self.Index>)
    
    mutating func removeAny(_: Element)
    
    mutating func removeFirst(_: Element)
    
    mutating func removeLast(_: Element)
    
    mutating func removeAll(_: Element)
    
}

extension SortedOperations {
    
    @inline(__always)
    public func anyIndex(of element: Element) -> Self.Index? {
        let (found, index) = self.search(for: element)
        return found ? index : nil
    }
    
    @inline(__always)
    public func count(of element: Element) -> Int {
        return self.find(element).count
    }
    
    @inline(__always)
    public func count(leftOf element: Element) -> Int {
        return self.left(of: element).count
    }
    
    @inline(__always)
    public func count(rightOf element: Element) -> Int {
        return self.right(of: element).count
    }
    
    @inline(__always)
    public func count(leftOfAndIncluding element: Element) -> Int {
        return self.left(ofAndIncluding: element).count
    }
    
    @inline(__always)
    public func count(rightOfAndIncluding element: Element) -> Int {
        return self.right(ofAndIncluding: element).count
    }
    
    @inline(__always)
    public func contains(_ element: Element) -> Bool {
        return self.anyIndex(of: element) != nil
    }
    
    @inline(__always)
    public func range(of element: Element) -> Range<Self.Index> {
        guard let startIndex = self.firstIndex(of: element), let endIndex = self.lastIndex(of: element) else {
            return self.endIndex ..< self.endIndex
        }
        return startIndex ..< self.index(after: endIndex)
    }
    
    @inline(__always)
    public func find(_ element: Element) -> Self.SubSequence {
        return self[self.range(of: element)]
    }
    
    @inline(__always)
    public func left(of element: Element) -> Self.SubSequence {
        return self[self.startIndex ..< (self.firstIndex(of: element) ?? self.startIndex)]
    }
    
    @inline(__always)
    public func left(ofAndIncluding element: Element) -> Self.SubSequence {
        return self[self.startIndex ..< (self.lastIndex(of: element).map { self.index(after: $0) } ?? self.startIndex)]
    }
    
    @inline(__always)
    public func right(of element: Element) -> Self.SubSequence {
        return self[(self.lastIndex(of: element).map { self.index(after: $0) } ?? self.endIndex) ..< self.endIndex]
    }
    
    @inline(__always)
    public func right(ofAndIncluding element: Element) -> Self.SubSequence {
        return self[(self.firstIndex(of: element) ?? self.endIndex) ..< self.endIndex]
    }
    
    @inline(__always)
    public mutating func removeAny(_ element: Element) {
        guard let index = self.anyIndex(of: element) else {
            return
        }
        _ = self.remove(at: index)
    }
    
    @inline(__always)
    public mutating func removeFirst(_ element: Element) {
        guard let index = self.firstIndex(of: element) else {
            return
        }
        _ = self.remove(at: index)
    }
    
    @inline(__always)
    public mutating func removeLast(_ element: Element) {
        guard let index = self.lastIndex(of: element) else {
            return
        }
        _ = self.remove(at: index)
    }
    
    @inline(__always)
    public mutating func removeAll(_ element: Element) {
        self.removeSubrange(self.range(of: element))
    }
    
}

extension SortedOperations where Self.SubSequence: SortedOperations {
    
    @inline(__always)
    public func firstIndex(of element: Element) -> Self.Index? {
        guard let index = self.anyIndex(of: element) else {
            return nil
        }
        return self[self.startIndex ..< index].firstIndex(of: element) ?? index
    }
    
    @inline(__always)
    public func lastIndex(of element: Element) -> Self.Index? {
        guard let index = self.anyIndex(of: element) else {
            return nil
        }
        return self[self.index(after: index) ..< self.endIndex].lastIndex(of: element) ?? index
    }
    
}

extension SortedOperations where Self: ComparatorContainer {
    
    public func search(for element: Element) -> (Bool, Self.Index) {
        var lower = 0
        var upper = self.count - 1
        while lower <= upper {
            let offset = (lower + upper) / 2
            let currentIndex = self.index(self.startIndex, offsetBy: offset)
            switch self.comparator.compare(lhs: self[currentIndex], rhs: element) {
            case .orderedSame:
                return (true, currentIndex)
            case .orderedDescending:
                upper = offset - 1
            case .orderedAscending:
                lower = offset + 1
            }
        }
        return (false, self.index(self.startIndex, offsetBy: lower))
    }
    
}
