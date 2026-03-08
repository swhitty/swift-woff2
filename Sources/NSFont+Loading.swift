//
//  NSFont+Loading.swift
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

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
public import class AppKit.NSFont
public import class Foundation.Bundle
public import struct Foundation.Data
import CoreText

extension NSFont {

    /// Creates an NSFont from font data (WOFF2, WOFF, TTF, or OTF)
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

    /// Creates an NSFont from a font file in a bundle (WOFF2, WOFF, TTF, or OTF)
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
