//
//  UIFontTests.swift
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
import UIKit
import Testing
@testable import WOFF2

struct UIFontTests {

    @Test
    func `loads WOFF2 font`() {
        let font = UIFont.woff2("Roboto-Regular.woff2", size: 16, in: .test)

        #expect(font != nil)
        #expect(font?.fontName == "RobotoRegular")
        #expect(font?.pointSize == 16)
    }

    @Test
    func `loads WOFF font`() {
        let font = UIFont.woff("Roboto-Regular.woff", size: 14, in: .test)

        #expect(font != nil)
        #expect(font?.fontName == "Roboto-Regular")
        #expect(font?.pointSize == 14)
    }

    @Test
    func `loads TTF font`() {
        let font = UIFont.ttf("Roboto-Regular.ttf", size: 12, in: .test)

        #expect(font != nil)
        #expect(font?.fontName == "RobotoRegular")
        #expect(font?.pointSize == 12)
    }

    @Test
    func `loads WOFF2 font with Dynamic Type`() {
        let font = UIFont.woff2("Roboto-Regular.woff2", size: 16, relativeTo: .body, in: .test)

        #expect(font != nil)
        #expect(font?.fontName == "RobotoRegular")
    }

    @Test
    func `returns nil for missing WOFF2`() {
        let font = UIFont.woff2("Missing.woff2", size: 16, in: .test)

        #expect(font == nil)
    }

    @Test
    func `returns nil for missing WOFF`() {
        let font = UIFont.woff("Missing.woff", size: 16, in: .test)

        #expect(font == nil)
    }

    @Test
    func `returns nil for missing TTF`() {
        let font = UIFont.ttf("Missing.ttf", size: 16, in: .test)

        #expect(font == nil)
    }
}
#endif
