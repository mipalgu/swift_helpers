/*
 * UnderlyingDataContainer.swift 
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


public protocol UnderlyingDataContainer {
    
    associatedtype Buffer
    
    var data: Buffer { get set }
    
}

extension UnderlyingDataContainer where
    Self: Sequence,
    Self.Buffer: Sequence,
    Self.Iterator == Self.Buffer.Iterator
{
    
    public func makeIterator() -> Self.Buffer.Iterator {
        return self.data.makeIterator()
    }
    
}

extension UnderlyingDataContainer where
    Self: Collection,
    Self.Buffer: Collection,
    Self.Index == Self.Buffer.Index,
    Self.Indices == Self.Buffer.Indices,
    Self.Iterator.Element == Self.Buffer.Element
{
    
    public var count: Int {
        return self.data.count
    }
    
    public var endIndex: Self.Index {
        return self.data.endIndex
    }
    
    public var first: Element? {
        return self.data.first
    }
    
    public var indices: Self.Indices {
        return self.data.indices
    }
    
    public var startIndex: Self.Index {
        return self.data.startIndex
    }
    
    public subscript(position: Self.Index) -> Element {
        return self.data[position]
    }
    
}

extension UnderlyingDataContainer where
    Self: BidirectionalCollection,
    Self.Buffer: BidirectionalCollection,
    Self.Index == Self.Buffer.Index,
    Self.Iterator.Element == Buffer.Iterator.Element
{
    
    public func index(after i: Self.Buffer.Index) -> Self.Buffer.Index {
        return self.data.index(after: i)
    }
    
    public func index(before i: Self.Buffer.Index) -> Self.Buffer.Index {
        return self.data.index(before: i)
    }
    
}

extension UnderlyingDataContainer where
    Self: RandomAccessCollection,
    Self.Buffer: RandomAccessCollection,
    Self.Index == Self.Buffer.Index,
    Self.Indices == Self.Buffer.Indices
{
    
    public func index(after i: Self.Buffer.Index) -> Self.Buffer.Index {
        return self.data.index(after: i)
    }
    
    public func index(before i: Self.Buffer.Index) -> Self.Buffer.Index {
        return self.data.index(before: i)
    }
    
}

extension UnderlyingDataContainer where Self: Equatable, Self.Buffer: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.data == rhs.data
    }
    
}

extension UnderlyingDataContainer where Self:Hashable, Self.Buffer: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.data)
    }
    
}
