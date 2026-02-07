//
//  FontCache.swift
//  swift-woff2
//
//  Created by Simon Whitty on 8/2/26.
//  Copyright 2026 Simon Whitty
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/swhitty/swift-woff2
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

import Foundation
import CoreText
import Synchronization

/// Namespace for font cache access
enum FontCache {

    /// Returns the shared font cache, using Mutex on macOS 15+ or NSLock on older platforms
    static var shared: some FontCaching {
        if #available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            return FontCacheMutex.shared
        } else {
            return FontCacheLock.shared
        }
    }
}

/// Font cache interface
protocol FontCaching: Sendable {
    func postScriptName(forResource name: String, in bundle: Bundle, loader: () -> CGFont?) -> String?
    func register(_ cgFont: CGFont)
}

// MARK: - Mutex-based cache (macOS 15+)

@available(macOS 15.0, iOS 18.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
final class FontCacheMutex: FontCaching, Sendable {

    static let shared = FontCacheMutex()

    private let storage = Mutex(Storage())

    private init() {}

    func postScriptName(
        forResource name: String,
        in bundle: Bundle,
        loader: () -> CGFont?
    ) -> String? {
        let key = Self.makeResourceKey(name: name, bundle: bundle)

        return storage.withLock { storage in
            if let cached = storage.resourceCache[key] {
                return cached
            }

            guard let cgFont = loader(),
                  let postScriptName = cgFont.postScriptName as String? else {
                return nil
            }

            storage.registerIfNeeded(cgFont, postScriptName: postScriptName)
            storage.resourceCache[key] = postScriptName
            return postScriptName
        }
    }

    func register(_ cgFont: CGFont) {
        guard let postScriptName = cgFont.postScriptName as String? else {
            return
        }
        storage.withLock { storage in
            storage.registerIfNeeded(cgFont, postScriptName: postScriptName)
        }
    }

    private static func makeResourceKey(name: String, bundle: Bundle) -> String {
        let bundleID = bundle.bundleIdentifier ?? bundle.bundlePath
        return "\(bundleID):\(name)"
    }

    private struct Storage: Sendable {
        var registeredFonts: Set<String> = []
        var resourceCache: [String: String] = [:]

        mutating func registerIfNeeded(_ cgFont: CGFont, postScriptName: String) {
            guard !registeredFonts.contains(postScriptName) else { return }
            CTFontManagerRegisterGraphicsFont(cgFont, nil)
            registeredFonts.insert(postScriptName)
        }
    }
}

// MARK: - NSLock-based cache (older platforms)

final class FontCacheLock: FontCaching, @unchecked Sendable {

    static let shared = FontCacheLock()

    private var registeredFonts: Set<String> = []
    private var resourceCache: [String: String] = [:]
    private let lock = NSLock()

    private init() {}

    func postScriptName(
        forResource name: String,
        in bundle: Bundle,
        loader: () -> CGFont?
    ) -> String? {
        let key = Self.makeResourceKey(name: name, bundle: bundle)

        lock.lock()
        defer { lock.unlock() }

        if let cached = resourceCache[key] {
            return cached
        }

        guard let cgFont = loader(),
              let postScriptName = cgFont.postScriptName as String? else {
            return nil
        }

        registerIfNeeded(cgFont, postScriptName: postScriptName)
        resourceCache[key] = postScriptName
        return postScriptName
    }

    func register(_ cgFont: CGFont) {
        guard let postScriptName = cgFont.postScriptName as String? else {
            return
        }
        lock.lock()
        defer { lock.unlock() }
        registerIfNeeded(cgFont, postScriptName: postScriptName)
    }

    private func registerIfNeeded(_ cgFont: CGFont, postScriptName: String) {
        guard !registeredFonts.contains(postScriptName) else { return }
        CTFontManagerRegisterGraphicsFont(cgFont, nil)
        registeredFonts.insert(postScriptName)
    }

    private static func makeResourceKey(name: String, bundle: Bundle) -> String {
        let bundleID = bundle.bundleIdentifier ?? bundle.bundlePath
        return "\(bundleID):\(name)"
    }
}

