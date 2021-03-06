/*
 * CommandLinePrinter.swift
 * swiftfsm
 *
 * Created by Callum McColl on 20/12/2015.
 * Copyright © 2015 Callum McColl. All rights reserved.
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

import swift_helpers

#if !NO_FOUNDATION && canImport(Foundation)
import Foundation
#endif

/**
 *  A printer that formats text so that it can be printed on the command line.
 */
public class CommandLinePrinter<
    T: TextOutputStream,
    U: TextOutputStream,
    V: TextOutputStream
>: GenericPrinter<T, U, V> {

    /**
     *  Create a `CommandLinePrinter`.
     *
     *  - Parameter errorStream: The `TextOutputStream` where the error messages
     *  are sent.
     *
     *  - Parameter messageStream: The `TextOutputStream` where the normal
     *  messages are sent.
     */
    public override init(errorStream: T, messageStream: U, warningStream: V) {
        super.init(errorStream: errorStream, messageStream: messageStream, warningStream: warningStream)
    }

    /**
     *  Formats `str` so that "error: " in red is printer before `str`.
     *
     *  - Parameter str: The error.
     */
    public override func error(str: String) {
        let pre = "error: "
        let str = self.space(str, length: pre.count)
        print(
            "\u{001B}[1;31m\(pre)\u{001B}[0m\(str)",
            terminator: "\n",
            to: &super.errorStream
        )
    }

    /**
     *  Formats `str` so that "warning: " in yellow is printed before `str`.
     *
     *  - Parameter str: The warning.
     */
    public override func warning(str: String) {
        let pre = "warning: "
        let str = self.space(str, length: pre.count)
        print(
            "\u{001B}[1;93m\(pre)\u{001B}[0m\(str)",
            terminator: "\n",
            to: &super.warningStream
        )
    }

    fileprivate func space(_ str: String, length: Int) -> String {
#if NO_FOUNDATION || !canImport(Foundation)
        let lines = str.split(separator: "\n")
#else
        let lines = str.components(separatedBy: .newlines)
#endif
        let spacedLines = lines.enumerated().map {
            $0 == 0 ? $1 : String([Character](repeating: " ", count: length)) + $1
        }
        return String(spacedLines.combine("") { $0 + "\n" + $1 })
    }

}
