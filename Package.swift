// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

//macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *

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
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TOOSC",
            targets: ["TOOSC"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TOOSC",
            dependencies: []),
        .testTarget(
            name: "TOOSCTests",
            dependencies: ["TOOSC"]),
    ]
)
