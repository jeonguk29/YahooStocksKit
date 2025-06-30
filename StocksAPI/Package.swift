// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StocksAPI",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "StocksAPI",
            targets: ["StocksAPI"]
        )
    ],
    targets: [
        .target(
            name: "StocksAPI"
        ),
        .testTarget(
            name: "StocksAPITests",
            dependencies: ["StocksAPI"]
        )
    ]
)
