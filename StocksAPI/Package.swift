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
    dependencies: [
        // YahooStocksKit 의존성 추가
        .package(url: "https://github.com/jeonguk29/YahooStocksKit.git", branch: "main")
    ],
    targets: [
        .target(
            name: "StocksAPI",
            dependencies: ["YahooStocksKit"]
        ),
        .testTarget(
            name: "StocksAPITests",
            dependencies: ["StocksAPI"]
        )
    ]
)
