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
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-collections",
            from: "0.0.1"
        ),
        .package(
            url: "https://github.com/apple/swift-algorithms",
            from: "0.1.0"
        ),
    ],
    targets: [
        .target(
            name: "Stackable",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "Algorithms", package: "swift-algorithms"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "StackableTests",
            dependencies: ["Stackable"],
            path: "Tests"
        ),
    ]
)
