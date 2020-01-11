// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ValidatateMate",
    products: [
        .library(
            name: "ValidatateMate",
            targets: ["ValidatateMate"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ValidatateMate",
            dependencies: []),
        .testTarget(
            name: "ValidatateMateTests",
            dependencies: ["ValidatateMate"]),
    ]
)
