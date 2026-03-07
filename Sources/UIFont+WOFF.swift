//
//  UIFont+WOFF.swift
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

#if canImport(UIKit)
public import class UIKit.UIFont
public import class Foundation.Bundle
public import struct Foundation.Data
import UIKit
import CoreText

extension UIFont {

    // MARK: - From Data

    /// Creates a UIFont from WOFF2 data
    /// - Parameters:
    ///   - data: The WOFF2 font data
    ///   - size: The point size of the font
    /// - Returns: A UIFont instance, or nil if the font cannot be parsed or registered
    public static func woff2(data: Data, size: CGFloat) -> UIFont? {
        makeFont(from: { try WOFF2(data: data) }, size: size)
    }

    /// Creates a UIFont from WOFF data
    /// - Parameters:
    ///   - data: The WOFF font data
    ///   - size: The point size of the font
    /// - Returns: A UIFont instance, or nil if the font cannot be parsed or registered
    public static func woff(data: Data, size: CGFloat) -> UIFont? {
        makeFont(from: { try WOFF(data: data) }, size: size)
    }

    /// Creates a UIFont from TTF/OTF data
    /// - Parameters:
    ///   - data: The TTF or OTF font data
    ///   - size: The point size of the font
    /// - Returns: A UIFont instance, or nil if the font cannot be parsed or registered
    public static func ttf(data: Data, size: CGFloat) -> UIFont? {
        makeFont(from: { try TTF(data: data) }, size: size)
    }

    /// Creates a UIFont from WOFF2 data that scales with Dynamic Type
    /// - Parameters:
    ///   - data: The WOFF2 font data
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to
    /// - Returns: A UIFont instance, or nil if the font cannot be parsed or registered
    public static func woff2(data: Data, size: CGFloat, relativeTo style: UIFont.TextStyle) -> UIFont? {
        guard let baseFont = woff2(data: data, size: size) else { return nil }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }

    /// Creates a UIFont from WOFF data that scales with Dynamic Type
    /// - Parameters:
    ///   - data: The WOFF font data
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to
    /// - Returns: A UIFont instance, or nil if the font cannot be parsed or registered
    public static func woff(data: Data, size: CGFloat, relativeTo style: UIFont.TextStyle) -> UIFont? {
        guard let baseFont = woff(data: data, size: size) else { return nil }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }

    /// Creates a UIFont from TTF/OTF data that scales with Dynamic Type
    /// - Parameters:
    ///   - data: The TTF or OTF font data
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to
    /// - Returns: A UIFont instance, or nil if the font cannot be parsed or registered
    public static func ttf(data: Data, size: CGFloat, relativeTo style: UIFont.TextStyle) -> UIFont? {
        guard let baseFont = ttf(data: data, size: size) else { return nil }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }

    // MARK: - From Bundle

    /// Creates a UIFont from a WOFF2 file in a bundle
    /// - Parameters:
    ///   - name: The filename of the WOFF2 font (e.g., "Roboto-Regular.woff2")
    ///   - size: The point size of the font
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A UIFont instance, or nil if the font cannot be loaded
    public static func woff2(_ name: String, size: CGFloat, in bundle: Bundle = .main) -> UIFont? {
        guard let postScriptName = Self.loadAndRegister(name: name, bundle: bundle, loader: WOFF2.init) else {
            return nil
        }
        return UIFont(name: postScriptName, size: size)
    }

    /// Creates a UIFont from a WOFF file in a bundle
    /// - Parameters:
    ///   - name: The filename of the WOFF font (e.g., "Roboto-Regular.woff")
    ///   - size: The point size of the font
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A UIFont instance, or nil if the font cannot be loaded
    public static func woff(_ name: String, size: CGFloat, in bundle: Bundle = .main) -> UIFont? {
        guard let postScriptName = Self.loadAndRegister(name: name, bundle: bundle, loader: WOFF.init) else {
            return nil
        }
        return UIFont(name: postScriptName, size: size)
    }

    /// Creates a UIFont from a TTF or OTF file in a bundle
    /// - Parameters:
    ///   - name: The filename of the TTF/OTF font (e.g., "Roboto-Regular.ttf")
    ///   - size: The point size of the font
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A UIFont instance, or nil if the font cannot be loaded
    public static func ttf(_ name: String, size: CGFloat, in bundle: Bundle = .main) -> UIFont? {
        guard let postScriptName = Self.loadAndRegister(name: name, bundle: bundle, loader: TTF.init) else {
            return nil
        }
        return UIFont(name: postScriptName, size: size)
    }

    /// Creates a UIFont from a WOFF2 file that scales with Dynamic Type
    /// - Parameters:
    ///   - name: The filename of the WOFF2 font (e.g., "Roboto-Regular.woff2")
    ///   - size: The base point size of the font
    ///   - relativeTo: The text style to scale relative to
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A UIFont instance, or nil if the font cannot be loaded
    public static func woff2(_ name: String, size: CGFloat, relativeTo style: UIFont.TextStyle, in bundle: Bundle = .main) -> UIFont? {
        guard let baseFont = woff2(name, size: size, in: bundle) else {
            return nil
        }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }

    /// Creates a UIFont from a WOFF file that scales with Dynamic Type
    /// - Parameters:
    ///   - name: The filename of the WOFF font (e.g., "Roboto-Regular.woff")
    ///   - size: The base point size of the font
    ///   - relativeTo: The text style to scale relative to
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A UIFont instance, or nil if the font cannot be loaded
    public static func woff(_ name: String, size: CGFloat, relativeTo style: UIFont.TextStyle, in bundle: Bundle = .main) -> UIFont? {
        guard let baseFont = woff(name, size: size, in: bundle) else {
            return nil
        }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }

    /// Creates a UIFont from a TTF or OTF file that scales with Dynamic Type
    /// - Parameters:
    ///   - name: The filename of the TTF/OTF font (e.g., "Roboto-Regular.ttf")
    ///   - size: The base point size of the font
    ///   - relativeTo: The text style to scale relative to
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A UIFont instance, or nil if the font cannot be loaded
    public static func ttf(_ name: String, size: CGFloat, relativeTo style: UIFont.TextStyle, in bundle: Bundle = .main) -> UIFont? {
        guard let baseFont = ttf(name, size: size, in: bundle) else {
            return nil
        }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }

    // MARK: - Private

    private static func makeFont(from loader: () throws -> some FontDataProvider, size: CGFloat) -> UIFont? {
        guard let font = try? loader(),
              let cgFont = try? font.makeCGFont(),
              let postScriptName = cgFont.postScriptName as String? else {
            return nil
        }
        FontCache.shared.register(cgFont)
        return UIFont(name: postScriptName, size: size)
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
