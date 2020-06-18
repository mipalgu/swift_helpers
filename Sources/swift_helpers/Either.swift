/*
 * Either.swift
 * swift_helpers
 *
 * Created by Callum McColl on 18/6/20.
 * Copyright © 2020 Callum McColl. All rights reserved.
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
 * A value which represents a possible choice between two distinct types
 * of values.
 *
 * `Either` provides the ability to specify two types of values for a field.
 * `Either` is similar to the concept of `Result` as well as `Optional`.
 * `Optional` and `Result` both model the idea of specifying two cases of
 * values --- the existence of a value or not in the case of `Optional` and
 * success or failure in the case of `Result`. `Either` represents the more
 * general case of simply having two types of values. `Either` represents
 * these two cases as either `left` or `right`.
 */
public enum Either<T, U> {
    
    /**
     *  A helpful getter for retrieving the `left` case. If `Self` is
     *  not `left` then this returns nil.
     */
    public var left: T? {
        switch self {
        case .left(let value):
            return value
        default:
            return nil
        }
    }
    
    /**
    *  A helpful getter for retrieving the `right` case. If `Self` is
    *  not `right` then this returns nil.
    */
    public var right: U? {
        switch self {
        case .right(let value):
            return value
        default:
            return nil
        }
    }
    
    /**
     *  The `left` case and associated value.
     */
    case left(_ value: T)
    
    /**
     *  The `right` case and associated value.
     */
    case right(_ value: U)
    
    /**
     *  Create a `left` case.
     *
     *  - Parameter `left`: The value associated with the left case.
     */
    public init(left value: T) {
        self = .left(value)
    }
    
    /**
     *  Create a `right` case.
     *
     *  - Parameter `right`: The value associated with the right case.
     */
    public init(right value: U) {
        self = .right(value)
    }
    
}

extension Either: Equatable where T: Equatable, U: Equatable {}
extension Either: Hashable where T: Hashable, U: Hashable {}
