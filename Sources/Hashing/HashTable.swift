/*
 * HashTable.swift 
 * Hashing 
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

public struct HashTable<T: Hashable> {

    fileprivate var table: [Int: T]

    public init() { self.table = [:] }

    public init(minimumCapacity: Int) {
        self.table = Dictionary(minimumCapacity: minimumCapacity)
    }

    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        self.init()
        sequence.forEach { self.insert($0) }
    }

    public init<C: Collection>(_ collection: C) where C.Iterator.Element == T {
        self.init(minimumCapacity: collection.count)
        collection.forEach { self.insert($0) }
    }

    public func contains(_ value: T) -> Bool {
        return nil != self.table[Hashing.hashValue(of: value)]
    }

    public mutating func insert(_ value: T) {
        self.table[Hashing.hashValue(of: value)] = value
    }

    public subscript(hashValue: Int) -> T? {
        return self.table[hashValue]
    }

}

extension HashTable: ExpressibleByArrayLiteral {

    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }

}

extension HashTable: Sequence {

    public func makeIterator() -> AnyIterator<T> {
        var i = self.table.startIndex
        return AnyIterator {
            if i == self.table.endIndex {
                return nil
            }
            defer { i = self.table.index(after: i) }
            return self.table[i].value
        }
    }

}

extension HashTable: Collection {

    public var count: Int {
        return self.table.count
    }

    public var endIndex: Dictionary<Int, T>.Index {
        return self.table.endIndex
    }

    public var first: T? {
        return self.table.first?.value
    }

    public var indices: Dictionary<Int, T>.Indices {
        return self.table.indices
    }

    public var startIndex: Dictionary<Int, T>.Index {
        return self.table.startIndex
    }

    public subscript(position: Dictionary<Int, T>.Index) -> T {
        return self.table[position].value
    }

    public func index(after i: Dictionary<Int, T>.Index) -> Dictionary<Int, T>.Index {
        return self.table.index(after: i)
    }

}

extension HashTable: CustomReflectable {

    public var customMirror: Mirror {
        return self.table.customMirror
    }

}

extension HashTable: Decodable where T: Decodable {

    public init(from decoder: Decoder) throws {
        self.table = try Dictionary<Int, T>(from: decoder)
    }

}

extension HashTable: Encodable where T: Encodable {

    public func encode(to encoder: Encoder) throws {
        try self.table.encode(to: encoder)
    }

}

extension HashTable: Equatable {
    
    public static func ==(lhs: HashTable<T>, rhs: HashTable<T>) -> Bool {
        return lhs.table == rhs.table
    }
}

extension HashTable: Hashable {

    public func hash(into hasher: inout Hasher) {
        self.table.hash(into: &hasher)
    }

}
