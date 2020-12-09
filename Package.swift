// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TOOSC",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v12),
        .watchOS(.v5),
        .tvOS(.v12)
    ],
    products: [
        .library(
            name: "TOOSC",
            targets: ["TOOSC"]),
    ],
    targets: [
        .target(
            name: "TOOSC",
            dependencies: []),
        .testTarget(
            name: "TOOSCTests",
            dependencies: ["TOOSC"]),
    ]
)
