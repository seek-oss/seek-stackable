// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stackable",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Stackable",
            targets: ["Stackable"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Stackable",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "StackableTests",
            dependencies: ["Stackable"],
            path: "Tests"
        ),
    ]
)
