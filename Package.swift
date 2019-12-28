// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift_helpers",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "swift_helpers",
            targets: ["swift_helpers"]),
        .library(
            name: "Functional",
            targets: ["Functional"]
        ),
        .library(
            name: "IO",
            targets: ["IO"]
        ),
        .library(
            name: "Hashing",
            targets: ["Hashing"]
        ),
        .library(
            name: "Trees",
            targets: ["Trees"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "swift_helpers",
            dependencies: []),
        .target(
            name: "Functional",
            dependencies: []),
        .target(
            name: "IO",
            dependencies: ["swift_helpers"]),
        .target(
            name: "Hashing",
            dependencies: []),
        .target(
            name: "Trees",
            dependencies: []),
        .testTarget(
            name: "swift_helpersTests",
            dependencies: ["swift_helpers"]),
        .testTarget(
            name: "HashingTests",
            dependencies: ["Hashing"]),
        .testTarget(
            name: "TreesTests",
            dependencies: ["Trees"])
    ]
)
