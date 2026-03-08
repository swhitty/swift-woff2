//
//  UIFont+Loading.swift
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
import class UIKit.UIFontMetrics
import CoreText

extension UIFont {

    /// Creates a UIFont from font data (WOFF2, WOFF, TTF, or OTF)
    /// - Parameters:
    ///   - data: The font data (format is auto-detected from magic bytes)
    ///   - size: The point size of the font
    public convenience init?(data: Data, size: CGFloat) {
        guard let font = try? makeFontDataProvider(data: data),
              let cgFont = try? font.makeCGFont(),
              let postScriptName = cgFont.postScriptName as String? else {
            return nil
        }
        FontCache.shared.register(cgFont)
        self.init(name: postScriptName, size: size)
    }

    /// Creates a UIFont from font data that scales with Dynamic Type
    /// - Parameters:
    ///   - data: The font data (format is auto-detected from magic bytes)
    ///   - size: The base point size of the font
    ///   - style: The text style to scale relative to
    /// - Returns: A UIFont instance, or nil if the font cannot be parsed or registered
    public static func scaledFont(data: Data, size: CGFloat, relativeTo style: UIFont.TextStyle) -> UIFont? {
        guard let baseFont = UIFont(data: data, size: size) else { return nil }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }

    /// Creates a UIFont from a font file in a bundle (WOFF2, WOFF, TTF, or OTF)
    /// - Parameters:
    ///   - filename: The filename of the font (e.g., "Roboto-Regular.woff2")
    ///   - size: The point size of the font
    ///   - bundle: The bundle containing the font file (defaults to .main)
    public convenience init?(filename: String, size: CGFloat, in bundle: Bundle = .main) {
        guard let postScriptName = Self.loadAndRegister(name: filename, bundle: bundle) else {
            return nil
        }
        self.init(name: postScriptName, size: size)
    }

    /// Creates a UIFont from a font file that scales with Dynamic Type
    /// - Parameters:try
    ///   - filename: The filename of the font (e.g., "Roboto-Regular.woff2")
    ///   - size: The base point size of the font
    ///   - relativeTo: The text style to scale relative to
    ///   - bundle: The bundle containing the font file (defaults to .main)
    /// - Returns: A UIFont instance, or nil if the font cannot be loaded
    public static func scaledFont(filename: String, size: CGFloat, relativeTo style: UIFont.TextStyle, in bundle: Bundle = .main) -> UIFont? {
        guard let baseFont = UIFont(filename: filename, size: size, in: bundle) else {
            return nil
        }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }

    // MARK: - Private

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
