// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProtobufCodable",
    products: [
        .library(
            name: "ProtobufCodable",
            targets: ["ProtobufCodable"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ProtobufCodable",
            dependencies: []),
        .testTarget(
            name: "ProtobufCodableTests",
            dependencies: ["ProtobufCodable"])
    ]
)
