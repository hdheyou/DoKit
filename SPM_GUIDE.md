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

### 2. SPM 限制和已知问题

⚠️ **重要限制**：由于某些依赖库不支持 Swift Package Manager，SPM 版本的功能有限制：

#### 不支持 SPM 的依赖

以下依赖库不支持 SPM，导致相关功能在纯 SPM 集成时不可用：

- **GCDWebServer**: 文件同步功能需要此库，但不支持 SPM
- **SocketRocket**: WebSocket 功能需要此库，但不支持 SPM  
- **Mantle**: 某些数据模型功能需要此库，但不支持 SPM

#### 解决方案

**方案 1：使用 CocoaPods（推荐）**

如果您的项目使用 CocoaPods，建议使用 CocoaPods 方式集成，这样可以获得完整功能：

```ruby
pod 'DoraemonKit/Core', '~> 3.0.4', :configurations => ['Debug']
```

**方案 2：混合使用 SPM + CocoaPods**

可以在使用 SPM 的同时，通过 CocoaPods 添加这些不支持 SPM 的依赖：

```ruby
pod 'GCDWebServer', '~> 3.5.4'
pod 'SocketRocket', '~> 0.6.0'
pod 'Mantle', '~> 2.2.0'
```

**方案 3：手动集成**

手动下载这些库的源码并添加到项目中。

### 3. 外部依赖

某些模块需要额外的依赖：

- **DoraemonKitLogger**: 需要 `CocoaLumberjack` ✅ 支持 SPM
- **DoraemonKitLoad**: 需要 `DoraemonLoadAnalyze.framework`（需要手动添加到项目）
- **DoraemonKitWeex**: 需要 `WeexSDK` 和 `WXDevtool`
- **DoraemonKitDatabase**: 需要 `YYDebugDatabase`
- **DoraemonKitMLeaksFinder**: 需要 `FBRetainCycleDetector`

### 4. Framework 依赖处理

对于需要 Framework 的模块（如 `DoraemonKitLoad`），您需要：

1. 将 Framework 文件添加到项目中
2. 在项目设置中链接 Framework
3. 或者使用 `binaryTarget` 方式（需要预先打包）

### 5. 资源文件

资源文件会自动包含在相应的模块中。确保在使用时通过正确的 Bundle 访问资源。

### 6. 编译设置

某些模块使用了特定的编译标志（如 `-Wall`, `-Wextra`），这可能会影响编译警告级别。

### 7. SPM 功能限制

由于依赖限制，SPM 版本可能无法使用以下功能：
- 文件同步功能（需要 GCDWebServer）
- WebSocket 相关功能（需要 SocketRocket）
- 某些数据模型功能（需要 Mantle）

如果您的项目需要这些功能，建议使用 CocoaPods 方式集成。

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

### Q: 如何解决 "could not be resolved" 或 "package manifest cannot be accessed" 错误？

A: 如果遇到依赖解析失败的问题，请按以下步骤操作：

1. **清理 Xcode 缓存**：
   - 在 Xcode 中，选择 `File` > `Packages` > `Reset Package Caches`
   - 或者删除 `~/Library/Developer/Xcode/DerivedData` 目录

2. **手动解析依赖**：
   - 在 Xcode 中，选择 `File` > `Packages` > `Resolve Package Versions`
   - 或者使用命令行：`xcodebuild -resolvePackageDependencies`

3. **检查网络连接**：
   - 确保可以访问 GitHub
   - 如果使用代理，确保 Xcode 配置了正确的代理设置

4. **检查仓库地址**：
   - 确保使用正确的仓库地址：`https://github.com/hdheyou/DoKit.git`
   - 如果是私有仓库，确保已配置正确的认证信息

5. **删除并重新添加依赖**：
   - 在 Xcode 项目设置中，删除有问题的包依赖
   - 清理项目（`Product` > `Clean Build Folder`）
   - 重新添加包依赖

6. **检查 Package.resolved 文件**：
   - 确保 `Package.resolved` 文件已提交到版本控制
   - 如果文件损坏，可以删除后让 Xcode 重新生成

7. **使用命令行验证**：
   ```bash
   cd /path/to/your/project
   swift package resolve
   ```

### Q: 如何解决 "unexpectedly did not find the new dependency in the package graph" 错误？

A: 这个错误通常表示 SPM 无法正确解析依赖关系。解决方法：

1. **确保 Package.swift 在仓库根目录**：
   - 检查远程仓库是否包含 `Package.swift` 文件
   - 确保文件在仓库的根目录，而不是子目录中

2. **检查分支和标签**：
   - 如果使用分支，确保分支名称正确（如 `main`）
   - 如果使用版本，确保标签存在且格式正确

3. **清理并重建**：
   ```bash
   # 删除 DerivedData
   rm -rf ~/Library/Developer/Xcode/DerivedData
   
   # 在项目目录中
   rm -rf .build
   rm Package.resolved
   
   # 重新解析
   swift package resolve
   ```

4. **检查依赖版本要求**：
   - 确保 `Package.swift` 中的依赖版本要求正确
   - 检查是否有版本冲突

## 技术支持

如有问题，请访问：
- 项目主页：https://www.dokit.cn
- GitHub Issues：https://github.com/didi/DoraemonKit/issues

## 版本要求

- iOS 9.0+
- Swift 5.5+
- Xcode 12.0+

