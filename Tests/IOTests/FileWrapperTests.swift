/*
 * FileWrapperTests.swift 
 * IOTests 
 *
 * Created by Morgan McColl on 03/10/2021.
 * Copyright © 2021 Morgan McColl. All rights reserved.
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
 *        This product includes software developed by Morgan McColl.
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

@testable import IO
import XCTest

public class FileWrapperTests: XCTestCase {

    private let packageRootPath = URL(fileURLWithPath: #file)
        .pathComponents.prefix(while: { $0 != "Tests" }).joined(separator: "/").dropFirst()

#if os(Linux)

    func testWriteFileWrapper() {
        guard let contents = "Hello World!".data(using: .utf8) else {
            XCTAssertTrue(false)
            return
        }
        let wrapper = FileWrapper(regularFileWithContents: contents)
        wrapper.preferredFilename = "FileWrapperTest.txt"
        let url = URL(fileURLWithPath: String(packageRootPath), isDirectory: true)
            .appendingPathComponent("Tests/IOTests/build/")
        do {
            try wrapper.write(to: url, originalContentsURL: nil)
            XCTAssertTrue(true)
        } catch {
            print(error)
            XCTAssertTrue(false)
        }
    }

    func testWriteDirectory() throws {
        guard let contents = "Subdir Hello World!".data(using: .utf8) else {
            XCTAssertTrue(false)
            return
        }
        let wrapper = FileWrapper(directoryWithFileWrappers: [:])
        wrapper.preferredFilename = "testDir"
        let wrapper2 = FileWrapper(regularFileWithContents: contents)
        wrapper2.preferredFilename = "data.txt"
        wrapper.addFileWrapper(wrapper2)
        let url = URL(fileURLWithPath: String(packageRootPath), isDirectory: true)
            .appendingPathComponent("Tests/IOTests/build")
        do {
            try wrapper.write(to: url, originalContentsURL: nil)
            XCTAssertTrue(true)
        } catch {
            print(error)
            XCTAssertTrue(false)
        }
    }

    func testOverwriteFile() {
        guard let contents = "Hello World!".data(using: .utf8) else {
            XCTAssertTrue(false)
            return
        }
        let fileName = "FileWrapperTest.txt"
        let wrapper = FileWrapper(regularFileWithContents: contents)
        wrapper.preferredFilename = fileName
        let url = URL(fileURLWithPath: String(packageRootPath), isDirectory: true)
            .appendingPathComponent("Tests/IOTests/build/")
        do {
            try wrapper.write(to: url, originalContentsURL: nil)
            XCTAssertTrue(true)
        } catch {
            print(error)
            XCTAssertTrue(false)
        }
        let newContents = "New Hello World!"
        guard let newData = newContents.data(using: .utf8) else {
            XCTAssertTrue(false)
            return
        }
        let newWrapper = FileWrapper(regularFileWithContents: newData)
        newWrapper.preferredFilename = fileName
        do {
            try newWrapper.write(to: url, originalContentsURL: nil)
            XCTAssertTrue(true)
        } catch {
            print(error)
            XCTAssertTrue(false)
        }
        guard let readContents = try? String(contentsOf: url.appendingPathComponent(fileName)) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(readContents, newContents)
    }

    func testOverwriteDirectory() {
        let contents = "Subdir Hello World!"
        guard let contentsData = contents.data(using: .utf8) else {
            XCTAssertTrue(false)
            return
        }
        let testDir = "testDir"
        let dataTxt = "data.txt"
        let wrapper = FileWrapper(directoryWithFileWrappers: [:])
        wrapper.preferredFilename = testDir
        let wrapper2 = FileWrapper(regularFileWithContents: contentsData)
        wrapper2.preferredFilename = dataTxt
        wrapper.addFileWrapper(wrapper2)
        let url = URL(fileURLWithPath: String(packageRootPath), isDirectory: true)
            .appendingPathComponent("Tests/IOTests/build")
        do {
            try wrapper.write(to: url, originalContentsURL: nil)
            XCTAssertTrue(true)
        } catch {
            print(error)
            XCTAssertTrue(false)
        }
        guard let originalContents = try? String(contentsOf: url.appendingPathComponent(testDir)
            .appendingPathComponent(dataTxt)) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(originalContents, contents)
        let newContents = "Subdir Hello World2!"
        guard let newContentsData = newContents.data(using: .utf8) else {
            XCTAssertTrue(false)
            return
        }
        let wrapperDir = FileWrapper(directoryWithFileWrappers: [:])
        wrapperDir.preferredFilename = testDir
        let dataWrapper = FileWrapper(regularFileWithContents: newContentsData)
        dataWrapper.preferredFilename = dataTxt
        wrapperDir.addFileWrapper(dataWrapper)
        do {
            try wrapperDir.write(to: url, originalContentsURL: nil)
            XCTAssertTrue(true)
        } catch {
            print(error)
            XCTAssertTrue(false)
        }
        guard let dataContents = try? String(contentsOf: url.appendingPathComponent(testDir)
            .appendingPathComponent(dataTxt)) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(dataContents, newContents)
    }

#endif

}
