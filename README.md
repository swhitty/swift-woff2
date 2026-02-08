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
    .package(url: "https://github.com/swhitty/swift-woff2.git", from: "0.1.0")
]
```

## Usage

### SwiftUI

Load fonts directly from your app bundle:

```swift
import SwiftUI
import WOFF2

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .font(.woff2("Silkscreen-Regular.woff2", size: 16))
    }
}

// With Dynamic Type scaling
Text("Hello, World!")
    .font(.woff2("Silkscreen-Regular.woff2", size: 17, relativeTo: .body))
```

Load a font from `Data` (e.g., downloaded from a server):

```swift
import SwiftUI
import WOFF2

struct ContentView: View {
    @State private var font: Font?

    var body: some View {
        Text("Hello, World!")
            .font(font)
            .task {
                let (data, _) = try await URLSession.shared.data(from: fontURL)
                font = .woff2(data: data, size: 24)
            }
    }
}
```

### UIKit

```swift
import UIKit
import WOFF2

label.font = .woff2("Silkscreen-Regular.woff2", size: 16)

// With Dynamic Type scaling
label.font = .woff2("Silkscreen-Regular.woff2", size: 17, relativeTo: .body)
```

### AppKit

```swift
import AppKit
import WOFF2

textField.font = .woff2("Silkscreen-Regular.woff2", size: 16)
textField.font = .woff("Silkscreen-Regular.woff", size: 16)
textField.font = .ttf("Silkscreen-Regular.ttf", size: 16)
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
- Variable font tables (gvar, fvar) are passed through without special handling

## Credits

Primarily the work of Simon Whitty, leaning heavily on [Claude Opus 4.5](https://www.anthropic.com/claude/opus), [google/woff2](https://github.com/google/woff2), and [fontkit](https://github.com/foliojs/fontkit).

## License

swift-woff2 is available under the zlib license. See the LICENSE file for more info.
