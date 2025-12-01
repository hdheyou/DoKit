// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DoraemonKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        // 核心产品
        .library(name: "DoraemonKit", targets: ["DoraemonKit"]),
        .library(name: "DoraemonKitCore", targets: ["DoraemonKitCore"]),
        .library(name: "DoraemonKitFoundation", targets: ["DoraemonKitFoundation"]),
        .library(name: "DoraemonKitCFoundation", targets: ["DoraemonKitCFoundation"]),
        .library(name: "DoraemonKitEventSynthesize", targets: ["DoraemonKitEventSynthesize"]),
        
        // 可选模块
        .library(name: "DoraemonKitLogger", targets: ["DoraemonKitLogger"]),
        .library(name: "DoraemonKitGPS", targets: ["DoraemonKitGPS"]),
        .library(name: "DoraemonKitLoad", targets: ["DoraemonKitLoad"]),
        .library(name: "DoraemonKitWeex", targets: ["DoraemonKitWeex"]),
        .library(name: "DoraemonKitDatabase", targets: ["DoraemonKitDatabase"]),
        .library(name: "DoraemonKitMLeaksFinder", targets: ["DoraemonKitMLeaksFinder"]),
        .library(name: "DoraemonKitMultiControl", targets: ["DoraemonKitMultiControl"]),
    ],
    dependencies: [
        // Core模块依赖
        .package(url: "https://github.com/swisspol/GCDWebServer.git", from: "3.5.4"),
        .package(url: "https://github.com/ccgus/fmdb.git", from: "2.7.5"),
        
        // Foundation模块依赖
        .package(url: "https://github.com/facebookarchive/SocketRocket.git", from: "0.6.0"),
        .package(url: "https://github.com/Mantle/Mantle.git", from: "2.2.0"),
        
        // Logger模块依赖
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.7.4"),
        
        // Weex模块依赖（可选，需要根据实际情况调整）
        // .package(url: "https://github.com/apache/incubator-weex.git", from: "0.28.0"),
    ],
    targets: [
        // MARK: - CFoundation模块
        .target(
            name: "DoraemonKitCFoundation",
            path: "iOS/DoKit/Classes/CFoundation",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .unsafeFlags(["-Wall", "-Wextra", "-Wpedantic", "-Werror", "-fvisibility=hidden"])
            ]
        ),
        
        // MARK: - Foundation模块
        .target(
            name: "DoraemonKitFoundation",
            dependencies: [
                .product(name: "SocketRocket", package: "SocketRocket"),
                .product(name: "Mantle", package: "Mantle"),
            ],
            path: "iOS/DoKit/Classes/Foundation",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .unsafeFlags(["-Wall", "-Wextra", "-Werror"])
            ]
        ),
        
        // MARK: - EventSynthesize模块
        .target(
            name: "DoraemonKitEventSynthesize",
            dependencies: [
                "DoraemonKitFoundation",
                "DoraemonKitCFoundation"
            ],
            path: "iOS/DoKit/Classes/EventSynthesize",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .unsafeFlags(["-Wall", "-Wextra", "-Wpedantic", "-Werror", "-fvisibility=hidden", "-Wno-gnu-conditional-omitted-operand", "-Wno-pointer-arith", "-Wno-gnu-zero-variadic-macro-arguments", "-Wno-unused-variable"])
            ],
            linkerSettings: [
                .linkedFramework("IOKit")
            ]
        ),
        
        // MARK: - Core模块
        .target(
            name: "DoraemonKitCore",
            dependencies: [
                .product(name: "GCDWebServer", package: "GCDWebServer"),
                .product(name: "FMDB", package: "fmdb"),
            ],
            path: "iOS/DoraemonKit/Src/Core",
            sources: ["."],
            resources: [
                .process("../../Resource")
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../Resource")
            ]
        ),
        
        // MARK: - Logger模块（可选）
        .target(
            name: "DoraemonKitLogger",
            dependencies: [
                "DoraemonKitCore",
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
            ],
            path: "iOS/DoraemonKit/Src/Logger",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithLogger")
            ]
        ),
        
        // MARK: - GPS模块（可选）
        .target(
            name: "DoraemonKitGPS",
            dependencies: [
                "DoraemonKitCore"
            ],
            path: "iOS/DoraemonKit/Src/GPS",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithGPS")
            ]
        ),
        
        // MARK: - Load模块（可选）
        // 注意：此模块依赖DoraemonLoadAnalyze.framework，需要手动添加到项目中
        .target(
            name: "DoraemonKitLoad",
            dependencies: [
                "DoraemonKitCore"
            ],
            path: "iOS/DoraemonKit/Src/MethodUseTime",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../Framework"),
                .define("DoraemonWithLoad")
            ]
            // 注意：DoraemonLoadAnalyze.framework需要作为binaryTarget或手动链接
        ),
        
        // MARK: - Weex模块（可选）
        .target(
            name: "DoraemonKitWeex",
            dependencies: [
                "DoraemonKitCore"
                // 注意：WeexSDK和WXDevtool需要单独处理，可能需要vendored frameworks
            ],
            path: "iOS/DoraemonKit/Src/Weex",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithWeex")
            ]
        ),
        
        // MARK: - Database模块（可选）
        .target(
            name: "DoraemonKitDatabase",
            dependencies: [
                "DoraemonKitCore"
                // 注意：YYDebugDatabase需要单独处理
            ],
            path: "iOS/DoraemonKit/Src/Database",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithDatabase")
            ]
        ),
        
        // MARK: - MLeaksFinder模块（可选）
        .target(
            name: "DoraemonKitMLeaksFinder",
            dependencies: [
                "DoraemonKitCore"
                // 注意：FBRetainCycleDetector需要单独处理
            ],
            path: "iOS/DoraemonKit/Src/MLeaksFinder",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithMLeaksFinder")
            ]
        ),
        
        // MARK: - MultiControl模块（可选）
        .target(
            name: "DoraemonKitMultiControl",
            dependencies: [
                "DoraemonKitCore",
                "DoraemonKitFoundation"
            ],
            path: "iOS/DoraemonKit/Src/MultiControl",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithMultiControl")
            ]
        ),
        
        // MARK: - 主库（聚合所有基础模块）
        // 注意：此库提供了DoKit的Swift接口，实际功能由DoraemonKitCore提供
        .target(
            name: "DoraemonKit",
            dependencies: [
                "DoraemonKitCore",
                "DoraemonKitFoundation",
                "DoraemonKitCFoundation",
                "DoraemonKitEventSynthesize"
            ],
            path: "iOS/DoKit/Classes/Core",
            sources: ["DoKit.m", "DoKit.h", "DKTrayViewController.h", "DKTrayViewController.m"],
            resources: [
                .process("../../Assets")
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../Assets"),
                .headerSearchPath("../../DoraemonKit/Src/Core")
            ]
        ),
    ]
)

