//
//  Font+Loading.swift
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
import CoreText

extension Font {

    /// Creates a Font from font data that scales with Dynamic Type
    /// - Parameters:
    ///   - data: The font data (WOFF2, WOFF, TTF, or OTF — format is auto-detected)
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to (defaults to .body)
    /// - Returns: A Font instance, or nil if the font cannot be parsed or registered
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func custom(data: Data, size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font? {
        guard let postScriptName = makePostScriptName(data: data) else { return nil }
        return Font.custom(postScriptName, size: size, relativeTo: style)
    }

    /// Creates a Font from font data with a fixed size
    /// - Parameters:
    ///   - data: The font data (WOFF2, WOFF, TTF, or OTF — format is auto-detected)
    ///   - fixedSize: The fixed point size of the font (does not scale with Dynamic Type)
    /// - Returns: A Font instance, or nil if the font cannot be parsed or registered
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func custom(data: Data, fixedSize: CGFloat) -> Font? {
        guard let postScriptName = makePostScriptName(data: data) else { return nil }
        return Font.custom(postScriptName, fixedSize: fixedSize)
    }

    /// Creates a Font from a font file in a bundle that scales with Dynamic Type
    /// - Parameters:
    ///   - filename: The filename of the font (e.g., "Roboto-Regular.woff2")
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to (defaults to .body)
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A Font instance, or nil if the font cannot be loaded
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func custom(filename: String, size: CGFloat, relativeTo style: Font.TextStyle = .body, in bundle: Bundle = .main) -> Font? {
        guard let postScriptName = Self.loadAndRegister(name: filename, bundle: bundle) else {
            return nil
        }
        return Font.custom(postScriptName, size: size, relativeTo: style)
    }

    /// Creates a Font from a font file in a bundle with a fixed size
    /// - Parameters:
    ///   - filename: The filename of the font (e.g., "Roboto-Regular.woff2")
    ///   - fixedSize: The fixed point size of the font (does not scale with Dynamic Type)
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A Font instance, or nil if the font cannot be loaded
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    public static func custom(filename: String, fixedSize: CGFloat, in bundle: Bundle = .main) -> Font? {
        guard let postScriptName = Self.loadAndRegister(name: filename, bundle: bundle) else {
            return nil
        }
        return Font.custom(postScriptName, fixedSize: fixedSize)
    }

    // MARK: - Private

    private static func makePostScriptName(data: Data) -> String? {
        guard let font = try? makeFontDataProvider(data: data),
              let cgFont = try? font.makeCGFont(),
              let postScriptName = cgFont.postScriptName as String? else {
            return nil
        }
        FontCache.shared.register(cgFont)
        return postScriptName
    }

    private static func loadAndRegister(
        name: String,
        bundle: Bundle
    ) -> String? {
        FontCache.shared.postScriptName(forResource: name, in: bundle) {
            guard let url = bundle.url(forResource: name, withExtension: nil),
                  let data = try? Data(contentsOf: url),
                  let font = try? makeFontDataProvider(data: data),
                  let cgFont = try? font.makeCGFont() else {
                return nil
            }
            return cgFont
        }
    }
}
#endif
