// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DoKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        // MARK: - 核心产品（必选）
        .library(name: "DoraemonKit", targets: ["DoraemonKit"]),
        .library(name: "DoraemonKitCore", targets: ["DoraemonKitCore"]),
        .library(name: "DoraemonKitFoundation", targets: ["DoraemonKitFoundation"]),
        .library(name: "DoraemonKitCFoundation", targets: ["DoraemonKitCFoundation"]),
        .library(name: "DoraemonKitEventSynthesize", targets: ["DoraemonKitEventSynthesize"]),
        
        // MARK: - 可选模块
        .library(name: "DoraemonKitLogger", targets: ["DoraemonKitLogger"]),
        .library(name: "DoraemonKitGPS", targets: ["DoraemonKitGPS"]),
        .library(name: "DoraemonKitLoad", targets: ["DoraemonKitLoad"]),
        .library(name: "DoraemonKitWeex", targets: ["DoraemonKitWeex"]),
        .library(name: "DoraemonKitDatabase", targets: ["DoraemonKitDatabase"]),
        .library(name: "DoraemonKitMLeaksFinder", targets: ["DoraemonKitMLeaksFinder"]),
        .library(name: "DoraemonKitMultiControl", targets: ["DoraemonKitMultiControl"]),
    ],
    dependencies: [
        // 外部 SPM 依赖
        .package(url: "https://github.com/ccgus/fmdb.git", from: "2.7.5"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.7.4"),
        
        // 注意：GCDWebServer、SocketRocket 和 Mantle 的源码已直接包含在项目中
        // 位于 iOS/Dependencies/ 目录下，作为本地模块使用
    ],
    targets: [
        // MARK: - 本地依赖模块（源码依赖，需先定义）
        
        // GCDWebServer 模块
        .target(
            name: "GCDWebServer",
            dependencies: [],
            path: "iOS/Dependencies/GCDWebServer",
            sources: ["Core", "Requests", "Responses"],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Core"),
                .headerSearchPath("Requests"),
                .headerSearchPath("Responses")
            ]
        ),
        
        // SocketRocket 模块
        .target(
            name: "SocketRocket",
            dependencies: [],
            path: "iOS/Dependencies/SocketRocket",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Internal"),
                .headerSearchPath("Internal/Delegate"),
                .headerSearchPath("Internal/IOConsumer"),
                .headerSearchPath("Internal/Proxy"),
                .headerSearchPath("Internal/RunLoop"),
                .headerSearchPath("Internal/Security"),
                .headerSearchPath("Internal/Utilities")
            ],
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("Security"),
                .linkedFramework("CFNetwork")
            ]
        ),
        
        // Mantle 模块
        .target(
            name: "Mantle",
            dependencies: [],
            path: "iOS/Dependencies/Mantle",
            sources: [".", "extobjc"],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("extobjc/include"),
                .headerSearchPath(".")
            ]
        ),
        
        // MARK: - 核心基础模块
        
        // CFoundation 模块
        .target(
            name: "DoraemonKitCFoundation",
            dependencies: [],
            path: "iOS/DoKit/Classes/CFoundation",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .unsafeFlags(["-Wall", "-Wextra", "-Wpedantic", "-Werror", "-fvisibility=hidden"])
            ]
        ),
        
        // Foundation 模块
        .target(
            name: "DoraemonKitFoundation",
            dependencies: ["SocketRocket", "Mantle"],
            path: "iOS/DoKit/Classes/Foundation",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .unsafeFlags(["-Wall", "-Wextra", "-Werror"])
            ],
            linkerSettings: [
                .linkedFramework("Security"),
                .linkedFramework("CFNetwork")
            ]
        ),
        
        // EventSynthesize 模块
        .target(
            name: "DoraemonKitEventSynthesize",
            dependencies: ["DoraemonKitFoundation", "DoraemonKitCFoundation"],
            path: "iOS/DoKit/Classes/EventSynthesize",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .unsafeFlags(["-Wall", "-Wextra", "-Wpedantic", "-Werror", "-fvisibility=hidden", 
                             "-Wno-gnu-conditional-omitted-operand", "-Wno-pointer-arith", 
                             "-Wno-gnu-zero-variadic-macro-arguments", "-Wno-unused-variable"])
            ],
            linkerSettings: [
                .linkedFramework("IOKit")
            ]
        ),
        
        // Core 模块
        .target(
            name: "DoraemonKitCore",
            dependencies: ["GCDWebServer", .product(name: "FMDB", package: "fmdb")],
            path: "iOS/DoraemonKit/Src/Core",
            sources: ["."],
            resources: [.process("../../Resource")],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../Resource")
            ]
        ),
        
        // MARK: - 主库（聚合所有基础模块）
        .target(
            name: "DoraemonKit",
            dependencies: [
                "DoraemonKitCore",
                "DoraemonKitFoundation",
                "DoraemonKitCFoundation",
                "DoraemonKitEventSynthesize"
            ],
            path: "iOS/DoKit/Classes",
            sources: [
                "Core/DoKit.m",
                "Core/DoKit.h",
                "Core/DKTrayViewController.h",
                "Core/DKTrayViewController.m",
                "Core/DoraemonKit.h",
                // Foundation 模块头文件（仅头文件，实现文件在 DoraemonKitFoundation 模块中）
                // 注意：这些头文件会按照路径结构暴露为 <DoraemonKit/Foundation/文件名.h>
                "Foundation/DKQRCodeScanLogic.h",
                "Foundation/DKQRCodeScanView.h",
                "Foundation/DKQRCodeScanViewController.h",
                "Foundation/DKMultiControlProtocol.h",
                "Foundation/DKMultiControlStreamManager.h",
                "Foundation/DKWebSocketSession.h",
                "Foundation/DTO/DKCommonDTOModel.h",
                "Foundation/DTO/DKActionDTOModel.h",
                "Foundation/DTO/DKDataRequestDTOModel.h",
                "Foundation/DTO/DKDataResponseDTOModel.h",
                "Foundation/DTO/DKLoginDataDTOModel.h",
                "Foundation/NSURLSessionConfiguration+DoKit.h",
            ],
            exclude: [
                "Foundation/*.m",
                "Foundation/DTO/*.m"
            ],
            resources: [.process("../Assets")],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("Core"),
                .headerSearchPath("Foundation"),
                .headerSearchPath("Foundation/DTO"),
                .headerSearchPath("../Assets"),
                .headerSearchPath("../../DoraemonKit/Src/Core")
            ]
        ),
        
        // MARK: - 可选功能模块
        
        // Logger 模块
        .target(
            name: "DoraemonKitLogger",
            dependencies: [
                "DoraemonKitCore",
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack")
            ],
            path: "iOS/DoraemonKit/Src/Logger",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithLogger")
            ]
        ),
        
        // GPS 模块
        .target(
            name: "DoraemonKitGPS",
            dependencies: ["DoraemonKitCore"],
            path: "iOS/DoraemonKit/Src/GPS",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithGPS")
            ]
        ),
        
        // Load 模块（方法耗时检测）
        // 注意：此模块依赖 DoraemonLoadAnalyze.framework，需要手动添加到项目中
        .target(
            name: "DoraemonKitLoad",
            dependencies: ["DoraemonKitCore"],
            path: "iOS/DoraemonKit/Src/MethodUseTime",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../Framework"),
                .define("DoraemonWithLoad")
            ]
        ),
        
        // Weex 模块
        // 注意：WeexSDK 和 WXDevtool 需要单独处理，可能需要 vendored frameworks
        .target(
            name: "DoraemonKitWeex",
            dependencies: ["DoraemonKitCore"],
            path: "iOS/DoraemonKit/Src/Weex",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithWeex")
            ]
        ),
        
        // Database 模块
        // 注意：YYDebugDatabase 需要单独处理
        .target(
            name: "DoraemonKitDatabase",
            dependencies: ["DoraemonKitCore"],
            path: "iOS/DoraemonKit/Src/Database",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithDatabase")
            ]
        ),
        
        // MLeaksFinder 模块
        // 注意：FBRetainCycleDetector 需要单独处理
        .target(
            name: "DoraemonKitMLeaksFinder",
            dependencies: ["DoraemonKitCore"],
            path: "iOS/DoraemonKit/Src/MLeaksFinder",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithMLeaksFinder")
            ]
        ),
        
        // MultiControl 模块
        .target(
            name: "DoraemonKitMultiControl",
            dependencies: ["DoraemonKitCore", "DoraemonKitFoundation"],
            path: "iOS/DoraemonKit/Src/MultiControl",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .define("DoraemonWithMultiControl")
            ]
        ),
    ]
)
