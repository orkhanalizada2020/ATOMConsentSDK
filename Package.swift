// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ATOMConsentSDK",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ATOMConsentSDK",
            targets: ["ATOMConsentSDK"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ATOMConsentSDKObjectiveC",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("./include"),
                .headerSearchPath("./include/ATS"),
                .headerSearchPath("./include/Configuration"),
                .headerSearchPath("./include/LocationAwareness"),
                .headerSearchPath("./include/SIMCode"),
                .headerSearchPath("./include/SystemInfo"),
                .headerSearchPath("./include/Timezone")
            ],
            swiftSettings: [
                .unsafeFlags(["-enable-library-evolution"])
            ]
        ),
        .target(
            name: "ATOMConsentSDK",
            dependencies: ["ATOMConsentSDKObjectiveC"],
            swiftSettings: [
                .unsafeFlags(["-enable-library-evolution"])
            ]
        ),
        .testTarget(
            name: "ATOMConsentSDKTests",
            dependencies: ["ATOMConsentSDK"]
        ),
    ]
)
