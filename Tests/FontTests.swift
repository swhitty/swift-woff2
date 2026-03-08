//
//  FontTests.swift
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

#if canImport(SwiftUI)
import SwiftUI
import Testing
@testable import WOFF2

struct FontTests {

    @Test
    func `loads WOFF2 font with relativeTo`() {
        guard #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) else { return }
        let font = Font.custom(filename: "Roboto-Regular.woff2", size: 16, relativeTo: .body, in: .test)
        #expect(font != nil)
        #expect(font != Font.system(size: 16))
    }

    @Test
    func `loads WOFF2 font with fixedSize`() {
        guard #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) else { return }
        let font = Font.custom(filename: "Roboto-Regular.woff2", fixedSize: 24, in: .test)
        #expect(font != nil)
        #expect(font != Font.system(size: 24))
    }

    @Test
    func `loads WOFF font with relativeTo`() {
        guard #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) else { return }
        let font = Font.custom(filename: "Roboto-Regular.woff", size: 14, relativeTo: .body, in: .test)
        #expect(font != nil)
        #expect(font != Font.system(size: 14))
    }

    @Test
    func `loads WOFF font with fixedSize`() {
        guard #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) else { return }
        let font = Font.custom(filename: "Roboto-Regular.woff", fixedSize: 18, in: .test)
        #expect(font != nil)
        #expect(font != Font.system(size: 18))
    }

    @Test
    func `loads TTF font with relativeTo`() {
        guard #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) else { return }
        let font = Font.custom(filename: "Roboto-Regular.ttf", size: 12, relativeTo: .body, in: .test)
        #expect(font != nil)
        #expect(font != Font.system(size: 12))
    }

    @Test
    func `loads TTF font with fixedSize`() {
        guard #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) else { return }
        let font = Font.custom(filename: "Roboto-Regular.ttf", fixedSize: 20, in: .test)
        #expect(font != nil)
        #expect(font != Font.system(size: 20))
    }

    @Test
    func `returns nil for missing font`() {
        guard #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) else { return }
        let font = Font.custom(filename: "Missing.woff2", size: 16, in: .test)
        #expect(font == nil)
    }
}
#endif
