// swift-tools-version: 6.2

/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2026
*  MIT license, see LICENSE file for details
*/

import PackageDescription

let package = Package(
    name: "SwiftUIScrollOffset",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SwiftUIScrollOffset", targets: ["SwiftUIScrollOffset"])
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "27.0.0")
    ],
    targets: [
        .target(
            name: "SwiftUIScrollOffset",
            dependencies: [.product(name: "SwiftUIIntrospect", package: "swiftui-introspect")]
        )
    ]
)
