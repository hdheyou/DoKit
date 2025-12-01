// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DoKit",
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
        .package(url: "https://github.com/ccgus/fmdb.git", from: "2.7.5"),
        
        // Logger模块依赖
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.7.4"),
        
        // 注意：GCDWebServer、SocketRocket 和 Mantle 的源码已直接包含在项目中
        // 位于 iOS/Dependencies/ 目录下，作为源码依赖使用
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
        // 注意：SocketRocket 和 Mantle 的源码已直接包含在项目中
        .target(
            name: "DoraemonKitFoundation",
            dependencies: [
                "SocketRocket",  // 使用本地源码依赖
                "Mantle",  // 使用本地源码依赖
            ],
            path: "iOS/DoKit/Classes/Foundation",
            sources: ["."],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../../Dependencies/SocketRocket"),  // SocketRocket 源码路径
                .headerSearchPath("../../Dependencies/Mantle/include"),  // Mantle 头文件路径
                .headerSearchPath("../../Dependencies/Mantle"),  // Mantle 源码路径
                .unsafeFlags(["-Wall", "-Wextra", "-Werror"])
            ],
            linkerSettings: [
                .linkedFramework("Security"),
                .linkedFramework("CFNetwork")
            ]
        ),
        
        // MARK: - SocketRocket 模块（源码依赖）
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
        
        // MARK: - Mantle 模块（源码依赖）
        .target(
            name: "Mantle",
            dependencies: [],
            path: "iOS/Dependencies/Mantle",
            sources: [
                ".",
                "extobjc"
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
                .headerSearchPath("extobjc/include"),
                .headerSearchPath(".")
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
        // 注意：GCDWebServer 的源码已直接包含在项目中
        .target(
            name: "DoraemonKitCore",
            dependencies: [
                "GCDWebServer",  // 使用本地源码依赖
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
                .headerSearchPath("../Resource"),
                .headerSearchPath("../../../Dependencies/GCDWebServer")  // GCDWebServer 源码路径
            ]
        ),
        
        // MARK: - GCDWebServer 模块（源码依赖）
        .target(
            name: "GCDWebServer",
            dependencies: [],
            path: "iOS/Dependencies/GCDWebServer",
            sources: [
                "Core",
                "Requests",
                "Responses"
            ],
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Core"),
                .headerSearchPath("Requests"),
                .headerSearchPath("Responses")
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
        // 为了兼容 CocoaPods 的使用方式，此库重新导出了 Foundation 模块的头文件
        // 通过包含 Foundation 目录下的头文件，使它们可以通过 <DoraemonKit/...> 访问
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
                // Core 模块文件
                "Core/DoKit.m",
                "Core/DoKit.h",
                "Core/DKTrayViewController.h",
                "Core/DKTrayViewController.m",
                "Core/DoraemonKit.h",
                // Foundation 模块头文件（仅头文件，实现文件在 DoraemonKitFoundation 模块中）
                // 注意：这些头文件会按照路径结构暴露，所以会暴露为 <DoraemonKit/Foundation/文件名.h>
                // 如果需要 <DoraemonKit/文件名.h>，需要调整路径或使用符号链接
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
                // 排除 Foundation 目录下的实现文件，它们属于 DoraemonKitFoundation 模块
                "Foundation/*.m",
                "Foundation/DTO/*.m"
            ],
            resources: [
                .process("../Assets")
            ],
            // publicHeadersPath 设置为 "." 意味着 sources 中的头文件会按照它们的路径结构暴露
            // 但由于我们需要它们暴露为 <DoraemonKit/文件名.h>，需要调整路径
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("Core"),
                .headerSearchPath("Foundation"),
                .headerSearchPath("Foundation/DTO"),
                .headerSearchPath("../Assets"),
                .headerSearchPath("../../DoraemonKit/Src/Core")
            ]
        ),
    ]
)

