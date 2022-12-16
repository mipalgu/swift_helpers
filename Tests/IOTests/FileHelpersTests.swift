// FileHelpersTests.swift
// swift_helpers
// 
// Created by Morgan McColl.
// Copyright © 2022 Morgan McColl. All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above
//    copyright notice, this list of conditions and the following
//    disclaimer in the documentation and/or other materials
//    provided with the distribution.
// 
// 3. All advertising materials mentioning features or use of this
//    software must display the following acknowledgement:
// 
//    This product includes software developed by Morgan McColl.
// 
// 4. Neither the name of the author nor the names of contributors
//    may be used to endorse or promote products derived from this
//    software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 
// -----------------------------------------------------------------------
// This program is free software; you can redistribute it and/or
// modify it under the above terms or under the terms of the GNU
// General Public License as published by the Free Software Foundation;
// either version 2 of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, see http://www.gnu.org/licenses/
// or write to the Free Software Foundation, Inc., 51 Franklin Street,
// Fifth Floor, Boston, MA  02110-1301, USA.
// 

@testable import IO
import XCTest

/// Test class for ``FileHelper``.
final class FileHelpersTests: XCTestCase {

    /// The path to the root of the package.
    let packageRootPath = URL(fileURLWithPath: #file)
        .pathComponents.prefix { $0 != "Tests" }.joined(separator: "/").dropFirst()

    /// The path to the build folder.
    var buildPath: URL {
        URL(fileURLWithPath: String(packageRootPath), isDirectory: true)
            .appendingPathComponent("Tests/IOTests/build_helpers", isDirectory: true)
    }

    /// A path to a simple text file.
    var filePath: URL {
        buildPath.appendingPathComponent("file.txt", isDirectory: false)
    }

    /// The helper under test.
    var helper = FileHelpers()

    /// A helper file manager.
    let manager = FileManager()

    /// Create the build dir before every test.
    override func setUpWithError() throws {
        helper = FileHelpers()
        try manager.createDirectory(at: buildPath, withIntermediateDirectories: true)
    }

    /// Remove the build dir after every test.
    override func tearDownWithError() throws {
        try manager.removeItem(at: buildPath)
    }

    /// Test changeCWD updates cwd property.
    func testCurrentDirectory() {
        XCTAssertEqual(
            URL(fileURLWithPath: helper.cwd?.absoluteString ?? "/tmp", isDirectory: true),
            URL(fileURLWithPath: String(packageRootPath), isDirectory: true)
        )
        XCTAssertTrue(helper.changeCWD(toPath: buildPath))
        XCTAssertEqual(
            URL(fileURLWithPath: helper.cwd?.absoluteString ?? "/tmp", isDirectory: true), buildPath
        )
    }

    /// Test fileExists method works correctly.
    func testFileExists() throws {
        guard let data = "Hello World!".data(using: .utf8) else {
            XCTFail("Failed to encode data.")
            return
        }
        guard manager.createFile(atPath: filePath.path, contents: data) else {
            XCTFail("Failed to create file \(filePath.absoluteString).")
            return
        }
        print(filePath.path)
        defer { _ = try? manager.removeItem(at: filePath) }
        XCTAssertTrue(helper.fileExists(filePath.path))
        XCTAssertFalse(helper.fileExists(buildPath.path + "/nonexistent"))
    }

}
