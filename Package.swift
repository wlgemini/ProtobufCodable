// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProtobufCodable",
    products: [
        .library(name: "BinaryUtil", targets: ["BinaryUtil"]),
        .library(name: "ProtobufCodable", targets: ["ProtobufCodable"])
    ],
    targets: [
        .target(name: "BinaryUtil", dependencies: []),
        .target(name: "ProtobufCodable", dependencies: ["BinaryUtil"]),
        .testTarget(name: "ProtobufCodableTests", dependencies: ["BinaryUtil", "ProtobufCodable"])
    ]
)
