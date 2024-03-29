/*
 * FileHelpers.swift 
 * Sources 
 *
 * Created by Callum McColl on 02/04/2017.
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

public final class FileHelpers {

    fileprivate let fm: FileManager

    public var cwd: URL? {
        URL(string: self.fm.currentDirectoryPath)
    }

    public init(fm: FileManager = FileManager.default) {
        self.fm = fm
    }

    public func changeCWD(toPath path: URL) -> Bool {
        self.fm.changeCurrentDirectoryPath(path.path)
    }

    public func createDirectory(atPath path: URL) -> Bool {
        (try? self.fm.createDirectory(
            at: path,
            withIntermediateDirectories: false
        )) != nil
    }

    public func createFile(atPath path: URL, withContents str: String) -> Bool {
        guard let encoded = str.data(using: String.Encoding.utf8) else {
            return false
        }
        return self.fm.createFile(atPath: path.path, contents: encoded)
    }

    public func createFile(_ name: String, inDirectory dir: URL, withContents str: String) -> URL? {
        let path = dir.appendingPathComponent(name, isDirectory: false)
        guard self.createFile(atPath: path, withContents: str) else {
            return nil
        }
        return path
    }

    public func deleteItem(atPath path: URL) -> Bool {
        if !self.fm.fileExists(atPath: path.path) {
            return true
        }
        return (try? self.fm.removeItem(at: path)) != nil
    }

    public func directoryExists(_ dir: String) -> Bool {
        var directoryExists: ObjCBool = false
        _ = self.fm.fileExists(atPath: dir, isDirectory: &directoryExists)
        return directoryExists.boolValue
    }

    public func fileExists(_ dir: String) -> Bool {
        self.fm.fileExists(atPath: dir)
    }

    public func makeSubDirectory(_ subdir: String, inDirectory dir: URL) -> URL? {
        let fullPath = dir.appendingPathComponent(subdir, isDirectory: true)
        guard self.createDirectory(atPath: fullPath) else {
            return nil
        }
        return fullPath
    }

    public func overwriteDirectory(_ dir: URL) -> URL? {
        guard
            self.deleteItem(atPath: dir),
            self.createDirectory(atPath: dir)
        else {
            return nil
        }
        return dir
    }

    public func overwriteDirectory(_ dir: URL, ignoringSubFiles subfiles: [URL]) -> URL? {
        guard !subfiles.isEmpty, let contents = try? self.fm.contentsOfDirectory(atPath: dir.path) else {
            return self.overwriteDirectory(dir)
        }
        let deleteFiles = contents.lazy.map { URL(fileURLWithPath: $0) }.filter { subfile in
            nil == subfiles.first {
                $0.absoluteURL == subfile.absoluteURL
            } && (true == subfile.isFileURL || nil == subfiles.first { self.path($0, isWithin: subfile) })
        }
        deleteFiles.forEach { _ = self.deleteItem(atPath: $0) }
        return dir
    }

    public func overwriteSubDirectory(
        _ subdir: String, inDirectory dir: URL, ignoringSubFiles subfiles: [URL] = []
    ) -> URL? {
        let fullPath = dir.appendingPathComponent(subdir, isDirectory: true)
        return self.overwriteDirectory(fullPath, ignoringSubFiles: subfiles)
    }

    public func path(_ path: URL, isWithin parent: URL) -> Bool {
        let zipped = zip(path.absoluteURL.pathComponents, parent.absoluteURL.pathComponents)
        return nil == zipped.reversed().first { $0 != $1 }
    }

    public func read(_ file: URL) -> String? {
        (try? Data(contentsOf: file)).flatMap { String(data: $0, encoding: .utf8) }
    }

    public func read(_ file: String) -> String? {
        self.read(URL(fileURLWithPath: file))
    }

}
#endif
#endif
