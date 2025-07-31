// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLTC",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftLTC",
            targets: ["SwiftLTC"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftLTC",
            dependencies: ["CLibLTC"]
        ),
        .target(
           name: "CLibLTC",
           dependencies: [],
           exclude: [
           ],
           sources: [
               "./libltc/src/decoder.h",
               "./libltc/src/encoder.h",
               "./libltc/src/ltc.h",
               "./libltc/src/decoder.c",
               "./libltc/src/encoder.c",
               "./libltc/src/ltc.c",
               "./libltc/src/timecode.c",
           ],
           publicHeadersPath: "./libltc/src",
           cSettings: [
                .headerSearchPath("./libltc/src"),
           ]
         ),
        .testTarget(
            name: "SwiftLTCTests",
            dependencies: ["SwiftLTC"]
        )
    ]
)
