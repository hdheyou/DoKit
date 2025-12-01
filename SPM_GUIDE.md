# DoraemonKit SPM 集成指南

本文档介绍如何使用 Swift Package Manager (SPM) 集成 DoraemonKit 到您的 iOS 项目中。

## 目录

- [模块说明](#模块说明)
- [快速开始](#快速开始)
- [模块选择](#模块选择)
- [使用示例](#使用示例)
- [注意事项](#注意事项)
- [迁移指南](#迁移指南)

## 模块说明

DoraemonKit 通过 SPM 提供了以下模块：

### 核心模块（必选）

- **DoraemonKitCore**: 核心功能模块，包含所有基础工具
- **DoraemonKitFoundation**: 基础功能模块，包含网络、WebSocket等
- **DoraemonKitCFoundation**: C语言基础模块
- **DoraemonKitEventSynthesize**: 事件合成模块
- **DoraemonKit**: 主库，聚合所有基础模块，提供统一入口

### 可选模块

- **DoraemonKitLogger**: 日志工具（需要 CocoaLumberjack）
- **DoraemonKitGPS**: GPS模拟定位功能
- **DoraemonKitLoad**: 方法耗时检测（需要 DoraemonLoadAnalyze.framework）
- **DoraemonKitWeex**: Weex专项工具（需要 WeexSDK）
- **DoraemonKitDatabase**: 数据库调试工具（需要 YYDebugDatabase）
- **DoraemonKitMLeaksFinder**: 内存泄漏检测（需要 FBRetainCycleDetector）
- **DoraemonKitMultiControl**: 一机多控功能

## 快速开始

### 1. 在 Xcode 中添加包依赖

1. 打开您的 Xcode 项目
2. 选择 `File` > `Add Packages...`
3. 输入仓库地址：`https://github.com/didi/DoraemonKit.git`
4. 选择版本或分支
5. 选择需要的产品（Products）

### 2. 基本集成（仅核心功能）

在 `Package.swift` 或 Xcode 包依赖中，选择以下产品：
- `DoraemonKit`（包含所有基础模块）

### 3. 在代码中使用

#### Objective-C

```objc
#import <DoraemonKit/DoraemonKit.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #ifdef DEBUG
        [[DoraemonManager shareInstance] install];
    #endif
    return YES;
}
```

#### Swift

```swift
import DoraemonKit

#if DEBUG
    DoraemonManager.shareInstance().install()
#endif
```

## 模块选择

### 最小化集成（仅核心功能）

```swift
dependencies: [
    .product(name: "DoraemonKit", package: "DoraemonKit")
]
```

### 完整集成（包含所有可选模块）

```swift
dependencies: [
    .product(name: "DoraemonKit", package: "DoraemonKit"),
    .product(name: "DoraemonKitLogger", package: "DoraemonKit"),
    .product(name: "DoraemonKitGPS", package: "DoraemonKit"),
    .product(name: "DoraemonKitLoad", package: "DoraemonKit"),
    .product(name: "DoraemonKitWeex", package: "DoraemonKit"),
    .product(name: "DoraemonKitDatabase", package: "DoraemonKit"),
    .product(name: "DoraemonKitMLeaksFinder", package: "DoraemonKit"),
    .product(name: "DoraemonKitMultiControl", package: "DoraemonKit"),
]
```

### 按需集成

根据您的需求选择特定模块：

```swift
dependencies: [
    .product(name: "DoraemonKit", package: "DoraemonKit"),
    .product(name: "DoraemonKitLogger", package: "DoraemonKit"),  // 如果需要日志功能
    .product(name: "DoraemonKitGPS", package: "DoraemonKit"),     // 如果需要GPS模拟
]
```

## 使用示例

### 基础使用

```swift
#if DEBUG
import DoraemonKit

// 默认安装
DoraemonManager.shareInstance().install()

// 或使用产品ID（平台端功能）
DoraemonManager.shareInstance().install(withPid: "your-product-id")

// 或自定义起始位置
DoraemonManager.shareInstance().install(withStartingPosition: CGPoint(x: 100, y: 100))
#endif
```

### 添加自定义插件

```swift
#if DEBUG
DoraemonManager.shareInstance().addPlugin(
    withTitle: "环境切换",
    icon: "doraemon_default",
    desc: "用于app内部环境切换功能",
    pluginName: "KDDoraemonEnvPlugin",
    atModule: "业务专区"
)
#endif
```

### 使用 DoKit Swift API

```swift
#if DEBUG
import DoraemonKit

// iOS 13+
if #available(iOS 13.0, *) {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        DoKit.install(withWindowScene: windowScene, productId: "your-product-id")
    }
} else {
    DoKit.install(withProductId: "your-product-id")
}
#endif
```

## 注意事项

### 1. 仅用于 Debug 环境

⚠️ **重要**：DoraemonKit 包含一些 hook 操作，可能会污染线上代码。请确保只在 Debug 环境中集成。

### 2. 外部依赖

某些模块需要额外的依赖：

- **DoraemonKitLogger**: 需要 `CocoaLumberjack`
- **DoraemonKitLoad**: 需要 `DoraemonLoadAnalyze.framework`（需要手动添加到项目）
- **DoraemonKitWeex**: 需要 `WeexSDK` 和 `WXDevtool`
- **DoraemonKitDatabase**: 需要 `YYDebugDatabase`
- **DoraemonKitMLeaksFinder**: 需要 `FBRetainCycleDetector`

### 3. Framework 依赖处理

对于需要 Framework 的模块（如 `DoraemonKitLoad`），您需要：

1. 将 Framework 文件添加到项目中
2. 在项目设置中链接 Framework
3. 或者使用 `binaryTarget` 方式（需要预先打包）

### 4. 资源文件

资源文件会自动包含在相应的模块中。确保在使用时通过正确的 Bundle 访问资源。

### 5. 编译设置

某些模块使用了特定的编译标志（如 `-Wall`, `-Wextra`），这可能会影响编译警告级别。

## 迁移指南

### 从 CocoaPods 迁移到 SPM

#### 之前（CocoaPods）

```ruby
pod 'DoraemonKit/Core', '~> 3.0.4', :configurations => ['Debug']
pod 'DoraemonKit/WithLogger', '~> 3.0.4', :configurations => ['Debug']
pod 'DoraemonKit/WithGPS', '~> 3.0.4', :configurations => ['Debug']
```

#### 之后（SPM）

在 Xcode 中添加包依赖，或使用 `Package.swift`：

```swift
dependencies: [
    .package(url: "https://github.com/didi/DoraemonKit.git", from: "3.0.4")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "DoraemonKit", package: "DoraemonKit"),
            .product(name: "DoraemonKitLogger", package: "DoraemonKit"),
            .product(name: "DoraemonKitGPS", package: "DoraemonKit"),
        ]
    )
]
```

### 模块对应关系

| CocoaPods Subspec | SPM Product |
|------------------|-------------|
| Core | DoraemonKitCore |
| Foundation | DoraemonKitFoundation |
| CFoundation | DoraemonKitCFoundation |
| EventSynthesize | DoraemonKitEventSynthesize |
| WithLogger | DoraemonKitLogger |
| WithGPS | DoraemonKitGPS |
| WithLoad | DoraemonKitLoad |
| WithWeex | DoraemonKitWeex |
| WithDatabase | DoraemonKitDatabase |
| WithMLeaksFinder | DoraemonKitMLeaksFinder |
| WithMultiControl | DoraemonKitMultiControl |

## 常见问题

### Q: 如何解决 "Module 'DoraemonKit' not found" 错误？

A: 确保：
1. 已正确添加包依赖
2. 在 Target 的 "Frameworks, Libraries, and Embedded Content" 中添加了模块
3. 使用了正确的 import 语句

### Q: 资源文件找不到怎么办？

A: 确保资源文件已正确包含在模块中。可以通过以下方式检查：

```swift
let bundle = Bundle(for: DoraemonManager.self)
let resourceURL = bundle.url(forResource: "DoraemonKit", withExtension: "bundle")
```

### Q: 如何禁用某些功能？

A: 只添加需要的模块即可。SPM 的模块化设计允许您按需选择功能。

## 技术支持

如有问题，请访问：
- 项目主页：https://www.dokit.cn
- GitHub Issues：https://github.com/didi/DoraemonKit/issues

## 版本要求

- iOS 9.0+
- Swift 5.5+
- Xcode 12.0+

