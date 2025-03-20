// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-mcp-gui",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/loopwork-ai/mcp-swift-sdk", branch: "main"),
        .package(url: "https://github.com/NakaokaRei/SwiftAutoGUI.git", exact: "0.3.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "swift-mcp-gui",
            dependencies: [
                .product(name: "MCP", package: "mcp-swift-sdk"),
                "SwiftAutoGUI"
            ]
        ),
    ]
)
