// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConsoleKit",
    platforms: [.iOS(.v17), .macOS(.v15), .watchOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ConsoleKit",
            targets: ["ConsoleUI", "ConsoleCore"]
        )
    ],
    targets: [
        .target(
            name: "ConsoleUI",
            dependencies: [
                "ConsoleCore"
            ]
        ),
        .target(
            name: "ConsoleCore"
        ),
        .testTarget(
            name: "ConsoleKitTests",
            dependencies: [
                "ConsoleUI",
                "ConsoleCore",
            ]
        ),
    ]
)
