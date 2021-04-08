// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InterfaceKit",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "InterfaceKit", targets: ["InterfaceKit"])
    ],
    dependencies: [],
    targets: [
        .target(name: "InterfaceKit", dependencies: []),
        .target(name: "MacApp", dependencies: ["InterfaceKit"]),
        .testTarget(name: "InterfaceKitTests", dependencies: ["InterfaceKit"]),
    ]
)
