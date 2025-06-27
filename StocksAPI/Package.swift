// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StocksAPI",
    platforms: [.iOS(.v16), .macOS(.v12), .watchOS(.v8), .tvOS(.v16)], // 라이브러리 지원 플랫폼 설정
    products: [
        .library(
            name: "StocksAPI",
            targets: ["StocksAPI"]),
        .executable(name: "StocksAPIExec", targets: ["StocksAPIExec"])
    ],
    targets: [
        .target(
            name: "StocksAPI"),
        .executableTarget(name: "StocksAPIExec",
                          dependencies: ["StocksAPI"]),
        .testTarget(
            name: "StocksAPITests",
            dependencies: ["StocksAPI"]
        ),
    ]
)
