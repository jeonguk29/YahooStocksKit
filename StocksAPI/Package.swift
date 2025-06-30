// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YahooStocksKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "YahooStocksKit",
            targets: ["StocksAPI"]
        ),
        .executable(
            name: "StocksAPIExec",
            targets: ["StocksAPIExec"]
        )
    ],
    targets: [
        .target(
            name: "StocksAPI",
            dependencies: [],
            path: "Sources/StocksAPI"
        ),
        .executableTarget(
            name: "StocksAPIExec",
            dependencies: ["StocksAPI"],
            path: "Sources/StocksAPIExec"
        ),
        .testTarget(
            name: "StocksAPITests",
            dependencies: ["StocksAPI"],
            path: "Tests/StocksAPITests"
        )
    ]
)
