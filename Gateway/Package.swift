// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Gateway",
    products: [
        .library(name: "Gateway", targets: ["Gateway"]),
    ],
    targets: [
        .target(
            name: "Gateway",
            path: "./Sources/Gateway"
        ),
    ]
)
