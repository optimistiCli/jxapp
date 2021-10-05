// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "jxapp",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "jxapp", targets: ["Main"])
    ],
    dependencies: [
        .package(name: "Iwstb", url: "https://github.com/optimistiCli/iwstb.git", from: "0.1.5"),
    ],
    targets: [
        .executableTarget(name: "Main", dependencies: ["Iwstb"], path: "Sources"),
    ]
)
