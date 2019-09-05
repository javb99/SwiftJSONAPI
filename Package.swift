// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JSONAPI",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "JSONAPISpec",
            targets: ["JSONAPISpec"]),
        .library(
            name: "CombineJSONAPI",
            targets: ["CombineJSONAPI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "JSONAPISpec",
            dependencies: []),
        .target(
            name: "CombineJSONAPI",
            dependencies: ["JSONAPISpec"]),
        .testTarget(
            name: "JSONAPISpecTests",
            dependencies: ["JSONAPISpec"]),
    ]
)
