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

#if os(Linux)

/// Test class for ``FileWrapper``.
class FileWrapperTests: XCTestCase {

    /// The path to the package root.
    private let packageRootPath = URL(fileURLWithPath: #file)
        .pathComponents.prefix { $0 != "Tests" }.joined(separator: "/").dropFirst()

    /// IO helper.
    let helper = FileHelpers()

    /// The path to the build folder.
    var buildPath: URL {
        URL(fileURLWithPath: String(packageRootPath), isDirectory: true)
            .appendingPathComponent("Tests/IOTests/build", isDirectory: true)
    }

    /// Create build path before every test.
    override func setUp() {
        if !helper.directoryExists(buildPath.absoluteString) {
            _ = helper.createDirectory(atPath: buildPath)
        }
    }

    /// Remove build folder after every test.
    override func tearDown() {
        _ = helper.deleteItem(atPath: buildPath)
    }

    /// Test wrapper can write a single file.
    func testWriteFileWrapper() throws {
        let raw = "Hello World!"
        guard let contents = raw.data(using: .utf8) else {
            XCTFail("Failed to create data!")
            return
        }
        let wrapper = FileWrapper(regularFileWithContents: contents)
        XCTAssertTrue(wrapper.isRegularFile)
        XCTAssertFalse(wrapper.isDirectory)
        wrapper.preferredFilename = "FileWrapperTest.txt"
        let path = buildPath.appendingPathComponent("FileWrapperTest.txt", isDirectory: false)
        try wrapper.write(to: path, originalContentsURL: nil)
        XCTAssertEqual(try String(contentsOf: path), raw)
    }

    /// Test wrapper can write a directory.
    func testWriteDirectory() throws {
        let raw = "Subdir Hello World!"
        guard let contents = raw.data(using: .utf8) else {
            XCTFail("Failed to create data!")
            return
        }
        let wrapper = FileWrapper(directoryWithFileWrappers: [:])
        XCTAssertTrue(wrapper.isDirectory)
        XCTAssertFalse(wrapper.isRegularFile)
        wrapper.preferredFilename = "testDir"
        let wrapper2 = FileWrapper(regularFileWithContents: contents)
        wrapper2.preferredFilename = "data.txt"
        XCTAssertEqual(wrapper.addFileWrapper(wrapper2), "data.txt")
        let testDir = buildPath.appendingPathComponent("testDir", isDirectory: true)
        try wrapper.write(to: testDir, originalContentsURL: nil)
        XCTAssertTrue(helper.directoryExists(testDir.path))
        let dataTxt = testDir.appendingPathComponent("data.txt", isDirectory: false)
        XCTAssertTrue(helper.fileExists(dataTxt.path))
        let data = try String(contentsOf: dataTxt)
        XCTAssertEqual(data, raw)
    }

    /// Test FileWrapper can overwrite a file.
    func testOverwriteFile() throws {
        let newContents = "New Hello World!"
        guard
            let contents = "Hello World!".data(using: .utf8), let newData = newContents.data(using: .utf8)
        else {
            XCTFail("Failed to create data.")
            return
        }
        let fileName = "FileWrapperTest.txt"
        let wrapper = FileWrapper(regularFileWithContents: contents)
        wrapper.preferredFilename = fileName
        let path = buildPath.appendingPathComponent(fileName, isDirectory: false)
        try wrapper.write(to: path, originalContentsURL: nil)
        let newWrapper = FileWrapper(regularFileWithContents: newData)
        newWrapper.preferredFilename = fileName
        try newWrapper.write(to: path, originalContentsURL: nil)
        guard let readContents = try? String(contentsOf: path) else {
            XCTFail("Failed to read file.")
            return
        }
        XCTAssertEqual(readContents, newContents)
    }

    /// Test FileWrapper successfully overwrite a directory with new data.
    func testOverwriteDirectory() throws {
        let contents = "Subdir Hello World!"
        guard let contentsData = contents.data(using: .utf8) else {
            XCTFail("Failed to convert contents to data.")
            return
        }
        let testDir = "testDir"
        let dataTxt = "data.txt"
        let wrapper = FileWrapper(directoryWithFileWrappers: [:])
        wrapper.preferredFilename = testDir
        let wrapper2 = FileWrapper(regularFileWithContents: contentsData)
        wrapper2.preferredFilename = dataTxt
        XCTAssertEqual(wrapper.addFileWrapper(wrapper2), dataTxt)
        let path = buildPath.appendingPathComponent(testDir, isDirectory: true)
        try wrapper.write(to: path, originalContentsURL: nil)
        guard let originalContents = try? String(
            contentsOf: path.appendingPathComponent(dataTxt, isDirectory: false)
        ) else {
            XCTFail("Failed to read new directory!")
            return
        }
        XCTAssertEqual(originalContents, contents)
        let newContents = "Subdir Hello World2!"
        guard let newContentsData = newContents.data(using: .utf8) else {
            XCTFail("Failed to convert new contents into data.")
            return
        }
        let wrapperDir = FileWrapper(directoryWithFileWrappers: [:])
        wrapperDir.preferredFilename = testDir
        let dataWrapper = FileWrapper(regularFileWithContents: newContentsData)
        dataWrapper.preferredFilename = dataTxt
        XCTAssertEqual(wrapperDir.addFileWrapper(dataWrapper), dataTxt)
        XCTAssertThrowsError(try wrapperDir.write(to: path, originalContentsURL: nil)) {
            XCTAssertEqual($0 as? FileWrapper.FileError, FileWrapper.FileError.fileAlreadyExists)
        }
        XCTAssertFalse(helper.directoryExists(path.path))
    }

    /// Test URL init reads folder contents correctly.
    func testURLInitDirectory() throws {
        XCTAssertTrue(helper.createFile(
            atPath: buildPath.appendingPathComponent("foo", isDirectory: false), withContents: "bar"
        ))
        let wrapper = try FileWrapper(url: buildPath)
        XCTAssertTrue(wrapper.isDirectory)
        XCTAssertFalse(wrapper.isRegularFile)
        XCTAssertEqual(wrapper.preferredFilename, "build")
        guard let fileContents = wrapper.fileWrappers, let data = "bar".data(using: .utf8) else {
            XCTFail("Failed to get file contents!")
            return
        }
        XCTAssertEqual(fileContents.count, 1)
        guard let file = fileContents["foo"] else {
            XCTFail("Failed to get file!")
            return
        }
        XCTAssertTrue(file.isRegularFile)
        XCTAssertEqual(file.preferredFilename, "foo")
        XCTAssertEqual(file.regularFileContents, data)
    }

}

#endif
