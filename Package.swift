// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stackable",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Stackable",
            targets: ["Stackable"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Stackable",
            dependencies: [],
            path: "Stackable/Sources"
        ),
        .testTarget(
            name: "StackableTests",
            dependencies: ["Stackable"],
             path: "Stackable/Tests"
        ),
    ]
)
