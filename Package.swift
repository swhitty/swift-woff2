// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "swift-woff2",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)
    ],
    products: [
        .library(
            name: "WOFF2",
            targets: ["WOFF2"]),
    ],
    targets: [
        .target(
            name: "WOFF2",
            path: "Sources",
            swiftSettings: .upcomingFeatures
        ),
        .testTarget(
            name: "WOFF2Tests",
            dependencies: ["WOFF2"],
            path: "Tests",
            resources: [
                .copy("Test.bundle")
            ],
            swiftSettings: .upcomingFeatures
        )
    ]
)

extension Array where Element == SwiftSetting {

    static var upcomingFeatures: [SwiftSetting] {
        [
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .swiftLanguageMode(.v6)
        ]
    }
}
