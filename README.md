[![Build](https://github.com/swhitty/swift-woff2/actions/workflows/build.yml/badge.svg)](https://github.com/swhitty/swift-woff2/actions/workflows/build.yml)
[![Codecov](https://codecov.io/gh/swhitty/swift-woff2/graphs/badge.svg)](https://codecov.io/gh/swhitty/swift-woff2)
[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswhitty%2Fswift-woff2%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/swhitty/swift-woff2)
[![Swift 6.0](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswhitty%2Fswift-woff2%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/swhitty/swift-woff2)


# swift-woff2

A native Swift library for decoding WOFF2, WOFF, TTF, and OTF font files.

## Features

- Extensions for `UIFont`, `NSFont`, and SwiftUI `Font` to load WOFF2, WOFF, TTF, and OTF fonts
- Dynamically load fonts from your app bundle or downloaded `Data`
- Supports Dynamic Type scaling with `relativeTo:` parameter
- Pure Swift implementation with no external dependencies

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swhitty/swift-woff2.git", from: "0.2.0")
]
```

## Usage

The font format is auto-detected from the file contents, so the same API works for WOFF2, WOFF, TTF, and OTF files.

### SwiftUI

Load fonts directly from your app bundle:

```swift
import SwiftUI
import WOFF2

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .font(.custom(filename: "Silkscreen-Regular.woff2", size: 16))
    }
}
```

Load a font from `Data` (e.g., downloaded from a server):

```swift
let (data, _) = try await URLSession.shared.data(from: fontURL)

Text("Hello, World!")
    .font(.custom(data: data, size: 24))

// With a fixed size (does not scale with Dynamic Type)
Text("Hello, World!")
    .font(.custom(data: data, fixedSize: 24))
```

### UIKit

```swift
import UIKit
import WOFF2

label.font = UIFont(filename: "Silkscreen-Regular.woff2", size: 16)

// With Dynamic Type scaling
label.font = .scaledFont(filename: "Silkscreen-Regular.woff2", size: 17, relativeTo: .body)

// From Data
label.font = UIFont(data: fontData, size: 16)
label.font = .scaledFont(data: fontData, size: 17, relativeTo: .body)
```

### AppKit

```swift
import AppKit
import WOFF2

textField.font = NSFont(filename: "Silkscreen-Regular.woff2", size: 16)

// From Data
textField.font = NSFont(data: fontData, size: 16)
```

## Supported Formats

| Format | Extension | Description |
|--------|-----------|-------------|
| WOFF2 | `.woff2` | Web Open Font Format 2.0 (Brotli compressed) |
| WOFF | `.woff` | Web Open Font Format 1.0 (zlib compressed) |
| TTF | `.ttf` | TrueType Font |
| OTF | `.otf` | OpenType Font |

## Limitations

- WOFF2 glyf/loca transform is implemented for TrueType outlines only
- CFF/CFF2 (PostScript) outline transforms are not yet supported

## Credits

Primarily the work of Simon Whitty, leaning heavily on [Claude Opus 4.5](https://www.anthropic.com/claude/opus), [google/woff2](https://github.com/google/woff2), and [fontkit](https://github.com/foliojs/fontkit).

## License

swift-woff2 is available under the zlib license. See the LICENSE file for more info.
