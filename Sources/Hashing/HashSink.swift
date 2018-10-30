/*
 * HashSink.swift 
 * Hashing 
 *
 * Created by Callum McColl on 13/10/2018.
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

/**
 *  Keeps a record of types.
 *
 *  This structure allows the lookup of types using their hash values. This is
 *  similar to Set and Dictionary, however, this structure does not store the
 *  actual values and instead only stores the hash values. This leads to (in
 *  most cases) a huge reduction in memory for algorithms which do not need to
 *  keep values in memory and instead only wish to know if a particular value
 *  has already been processed.
 *
 *  - Attention: Since this uses the swift standard library `Hasher`, please
 *  do not persist this structure as there is no guarantee that the hash values
 *  will be the same between different executions.
 */
public struct HashSink<RawData, CompressedData> where CompressedData: Hashable {

    fileprivate var compressor: AnyCompressor<RawData, CompressedData>

    fileprivate var sink: Set<CompressedData>

    /**
     *  Create an empty `HashSink`.
     *
     *  - Parameter compressor: The `Compressor` which will be used to minimise
     *  the size of the data within the sink.
     */
    public init(compressor: AnyCompressor<RawData, CompressedData>) {
        self.compressor = compressor
        self.sink = []
    }

    /**
     *  Creates an empty `HashSink` with preallocated space for at least the
     *  specified number of elements.
     *
     *  - Parameter compressor: The compressor which will be used to minimise
     *  the size of the data within the sink.
     *
     *  - Parameter minimumCapacity: The minimum number of elements that the
     *  newly created `HashSink` should be able to store without reallocating
     *  memory.
     */
    public init(compressor: AnyCompressor<RawData, CompressedData>, minimumCapacity: Int) {
        self.compressor = compressor
        self.sink = Set(minimumCapacity: minimumCapacity)
    }

    /**
     *  Does this sink already contain this value?
     */
    public func contains(_ value: RawData) -> Bool {
        return self.sink.contains(self.compressor.compress(value))
    }

    /**
     *  Empty the sink.
     */
    public mutating func drain() {
        self.sink = []
    }

    /**
     *  Insert a value into the sink.
     *
     *  - Postcondition: `contains(value)` will return true.
     */
    public mutating func insert(_ value: RawData) {
        self.sink.insert(self.compressor.compress(value))
    }

}

extension HashSink where RawData == CompressedData {

    /**
     *  Create an empty `HashSink`.
     */
    public init() {
        self.init(compressor: AnyCompressor(NullCompressor()))
    }

    /**
     *  Creates an empty `HashSink` with preallocated space for at least the
     *  specified number of elements.
     *
     *  - Parameter minimumCapacity: The minimum number of elements that the
     *  newly created `HashSink` should be able to store without reallocating
     *  memory.
     */
    public init(minimumCapacity: Int) {
        self.init(compressor: AnyCompressor(NullCompressor()), minimumCapacity: minimumCapacity)
    }

}
