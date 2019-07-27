// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSON-API",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "JSON-API",
            targets: ["JSON-API"]),
        .library(
            name: "CombineJSON-API",
            targets: ["CombineJSON-API"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "JSON-API",
            dependencies: []),
        .target(
            name: "CombineJSON-API",
            dependencies: ["JSON-API"]),
        .testTarget(
            name: "JSON-APITests",
            dependencies: ["JSON-API"]),
    ]
)
