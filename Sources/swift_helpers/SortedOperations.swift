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
    
    func anyLocation(of: Element) -> Index?
    
    func contains(_ element: Element) -> Bool
    
    func range(of: Element) -> Range<Index>
    
    func firstLocation(of: Element) -> Index?
    
    func lastLocation(of: Element) -> Index?
    
    func search(for: Element) -> (Bool, Index)
    
    func find(_: Element) -> Self.SubSequence
    
    func left(of: Element) -> Self.SubSequence
    
    func right(of: Element) -> Self.SubSequence
    
    mutating func insert(_: Element)
    
}

extension SortedOperations where Self.SubSequence: SortedOperations {
    
    public func anyLocation(of element: Element) -> Self.Index? {
        let (found, index) = self.search(for: element)
        return found ? index : nil
    }
    
    @inline(__always)
    public func contains(_ element: Element) -> Bool {
        return self.anyLocation(of: element) != nil
    }
    
    @inline(__always)
    public func range(of element: Element) -> Range<Self.Index> {
        guard let startIndex = self.firstLocation(of: element), let endIndex = self.lastLocation(of: element) else {
            return self.endIndex ..< self.endIndex
        }
        return startIndex ..< self.index(after: endIndex)
    }
    
    @inline(__always)
    public func firstLocation(of element: Element) -> Self.Index? {
        guard let index = self.anyLocation(of: element) else {
            return nil
        }
        return self[self.startIndex ..< index].firstLocation(of: element) ?? index
    }
    
    @inline(__always)
    public func lastLocation(of element: Element) -> Self.Index? {
        guard let index = self.anyLocation(of: element) else {
            return nil
        }
        return self[self.index(after: index) ..< self.endIndex].lastLocation(of: element) ?? index
    }
    
    @inline(__always)
    public func find(_ element: Element) -> Self.SubSequence {
        return self[self.range(of: element)]
    }
    
    @inline(__always)
    public func left(of element: Element) -> Self.SubSequence {
        return self[self.startIndex ..< (self.firstLocation(of: element) ?? self.startIndex)]
    }
    
    @inline(__always)
    public func left(ofAndIncluding element: Element) -> Self.SubSequence {
        return self[self.startIndex ..< (self.lastLocation(of: element).map { self.index(after: $0) } ?? self.startIndex)]
    }
    
    @inline(__always)
    public func right(of element: Element) -> Self.SubSequence {
        return self[(self.lastLocation(of: element).map { self.index(after: $0) } ?? self.endIndex) ..< self.endIndex]
    }
    
    @inline(__always)
    public func right(ofAndIncluding element: Element) -> Self.SubSequence {
        return self[(self.firstLocation(of: element) ?? self.endIndex) ..< self.endIndex]
    }
    
}
