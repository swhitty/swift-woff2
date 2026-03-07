//
//  Font+WOFF.swift
//  swift-woff2
//
//  Created by Simon Whitty on 7/2/26.
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

#if canImport(SwiftUI)
public import struct SwiftUI.Font
public import class Foundation.Bundle
public import struct Foundation.Data
import SwiftUI
import CoreText

extension Font {

    // MARK: - From Data

    /// Creates a Font from WOFF2 data that scales with Dynamic Type
    /// - Parameters:
    ///   - data: The WOFF2 font data
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to (defaults to .body)
    /// - Returns: A Font instance, or nil if the font cannot be parsed or registered
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func woff2(data: Data, size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font? {
        guard let postScriptName = makePostScriptName(from: { try WOFF2(data: data) }) else { return nil }
        return Font.custom(postScriptName, size: size, relativeTo: style)
    }

    /// Creates a Font from WOFF2 data with a fixed size
    /// - Parameters:
    ///   - data: The WOFF2 font data
    ///   - fixedSize: The fixed point size of the font (does not scale with Dynamic Type)
    /// - Returns: A Font instance, or nil if the font cannot be parsed or registered
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func woff2(data: Data, fixedSize: CGFloat) -> Font? {
        guard let postScriptName = makePostScriptName(from: { try WOFF2(data: data) }) else { return nil }
        return Font.custom(postScriptName, fixedSize: fixedSize)
    }

    /// Creates a Font from WOFF data that scales with Dynamic Type
    /// - Parameters:
    ///   - data: The WOFF font data
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to (defaults to .body)
    /// - Returns: A Font instance, or nil if the font cannot be parsed or registered
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func woff(data: Data, size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font? {
        guard let postScriptName = makePostScriptName(from: { try WOFF(data: data) }) else { return nil }
        return Font.custom(postScriptName, size: size, relativeTo: style)
    }

    /// Creates a Font from WOFF data with a fixed size
    /// - Parameters:
    ///   - data: The WOFF font data
    ///   - fixedSize: The fixed point size of the font (does not scale with Dynamic Type)
    /// - Returns: A Font instance, or nil if the font cannot be parsed or registered
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func woff(data: Data, fixedSize: CGFloat) -> Font? {
        guard let postScriptName = makePostScriptName(from: { try WOFF(data: data) }) else { return nil }
        return Font.custom(postScriptName, fixedSize: fixedSize)
    }

    /// Creates a Font from TTF/OTF data that scales with Dynamic Type
    /// - Parameters:
    ///   - data: The TTF or OTF font data
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to (defaults to .body)
    /// - Returns: A Font instance, or nil if the font cannot be parsed or registered
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func ttf(data: Data, size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font? {
        guard let postScriptName = makePostScriptName(from: { try TTF(data: data) }) else { return nil }
        return Font.custom(postScriptName, size: size, relativeTo: style)
    }

    /// Creates a Font from TTF/OTF data with a fixed size
    /// - Parameters:
    ///   - data: The TTF or OTF font data
    ///   - fixedSize: The fixed point size of the font (does not scale with Dynamic Type)
    /// - Returns: A Font instance, or nil if the font cannot be parsed or registered
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func ttf(data: Data, fixedSize: CGFloat) -> Font? {
        guard let postScriptName = makePostScriptName(from: { try TTF(data: data) }) else { return nil }
        return Font.custom(postScriptName, fixedSize: fixedSize)
    }

    // MARK: - From Bundle

    /// Creates a Font from a WOFF2 file in a bundle that scales with Dynamic Type
    /// - Parameters:
    ///   - name: The filename of the WOFF2 font (e.g., "Roboto-Regular.woff2")
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to (defaults to .body)
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A Font instance, or nil if the font cannot be loaded
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func woff2(_ name: String, size: CGFloat, relativeTo style: Font.TextStyle = .body, in bundle: Bundle = .main) -> Font? {
        guard let postScriptName = Self.loadAndRegister(name: name, bundle: bundle, loader: WOFF2.init) else {
            return nil
        }
        return Font.custom(postScriptName, size: size, relativeTo: style)
    }

    /// Creates a Font from a WOFF2 file in a bundle with a fixed size
    /// - Parameters:
    ///   - name: The filename of the WOFF2 font (e.g., "Roboto-Regular.woff2")
    ///   - fixedSize: The fixed point size of the font (does not scale with Dynamic Type)
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A Font instance, or nil if the font cannot be loaded
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func woff2(_ name: String, fixedSize: CGFloat, in bundle: Bundle = .main) -> Font? {
        guard let postScriptName = Self.loadAndRegister(name: name, bundle: bundle, loader: WOFF2.init) else {
            return nil
        }
        return Font.custom(postScriptName, fixedSize: fixedSize)
    }

    /// Creates a Font from a WOFF file in a bundle that scales with Dynamic Type
    /// - Parameters:
    ///   - name: The filename of the WOFF font (e.g., "Roboto-Regular.woff")
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to (defaults to .body)
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A Font instance, or nil if the font cannot be loaded
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func woff(_ name: String, size: CGFloat, relativeTo style: Font.TextStyle = .body, in bundle: Bundle = .main) -> Font? {
        guard let postScriptName = Self.loadAndRegister(name: name, bundle: bundle, loader: WOFF.init) else {
            return nil
        }
        return Font.custom(postScriptName, size: size, relativeTo: style)
    }

    /// Creates a Font from a WOFF file in a bundle with a fixed size
    /// - Parameters:
    ///   - name: The filename of the WOFF font (e.g., "Roboto-Regular.woff")
    ///   - fixedSize: The fixed point size of the font (does not scale with Dynamic Type)
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A Font instance, or nil if the font cannot be loaded
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func woff(_ name: String, fixedSize: CGFloat, in bundle: Bundle = .main) -> Font? {
        guard let postScriptName = Self.loadAndRegister(name: name, bundle: bundle, loader: WOFF.init) else {
            return nil
        }
        return Font.custom(postScriptName, fixedSize: fixedSize)
    }

    /// Creates a Font from a TTF or OTF file in a bundle that scales with Dynamic Type
    /// - Parameters:
    ///   - name: The filename of the TTF/OTF font (e.g., "Roboto-Regular.ttf")
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to (defaults to .body)
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A Font instance, or nil if the font cannot be loaded
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func ttf(_ name: String, size: CGFloat, relativeTo style: Font.TextStyle = .body, in bundle: Bundle = .main) -> Font? {
        guard let postScriptName = Self.loadAndRegister(name: name, bundle: bundle, loader: TTF.init) else {
            return nil
        }
        return Font.custom(postScriptName, size: size, relativeTo: style)
    }

    /// Creates a Font from a TTF or OTF file in a bundle with a fixed size
    /// - Parameters:
    ///   - name: The filename of the TTF/OTF font (e.g., "Roboto-Regular.ttf")
    ///   - fixedSize: The fixed point size of the font (does not scale with Dynamic Type)
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A Font instance, or nil if the font cannot be loaded
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func ttf(_ name: String, fixedSize: CGFloat, in bundle: Bundle = .main) -> Font? {
        guard let postScriptName = Self.loadAndRegister(name: name, bundle: bundle, loader: TTF.init) else {
            return nil
        }
        return Font.custom(postScriptName, fixedSize: fixedSize)
    }

    // MARK: - Private

    private static func makePostScriptName(from loader: () throws -> some FontDataProvider) -> String? {
        guard let font = try? loader(),
              let cgFont = try? font.makeCGFont(),
              let postScriptName = cgFont.postScriptName as String? else {
            return nil
        }
        FontCache.shared.register(cgFont)
        return postScriptName
    }

    private static func loadAndRegister<T: FontDataProvider>(
        name: String,
        bundle: Bundle,
        loader: (Data) throws -> T
    ) -> String? {
        FontCache.shared.postScriptName(forResource: name, in: bundle) {
            guard let url = bundle.url(forResource: name, withExtension: nil),
                  let data = try? Data(contentsOf: url),
                  let font = try? loader(data),
                  let cgFont = try? font.makeCGFont() else {
                return nil
            }
            return cgFont
        }
    }
}
#endif
