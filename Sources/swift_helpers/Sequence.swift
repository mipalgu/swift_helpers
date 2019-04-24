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
