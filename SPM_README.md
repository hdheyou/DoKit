# DoraemonKit SPM 组件

本项目已成功整理为 Swift Package Manager (SPM) 组件，可以通过 SPM 方式集成到 iOS 项目中。

## 📦 已创建的 SPM 组件

### 核心模块（必选）

1. **DoraemonKitCore** - 核心功能模块
2. **DoraemonKitFoundation** - 基础功能模块
3. **DoraemonKitCFoundation** - C语言基础模块
4. **DoraemonKitEventSynthesize** - 事件合成模块
5. **DoraemonKit** - 主库（聚合所有基础模块）

### 可选模块

1. **DoraemonKitLogger** - 日志工具
2. **DoraemonKitGPS** - GPS模拟定位
3. **DoraemonKitLoad** - 方法耗时检测
4. **DoraemonKitWeex** - Weex专项工具
5. **DoraemonKitDatabase** - 数据库调试工具
6. **DoraemonKitMLeaksFinder** - 内存泄漏检测
7. **DoraemonKitMultiControl** - 一机多控功能

## 📁 文件结构

```
DoKit/
├── Package.swift                    # SPM 包配置文件
├── SPM_GUIDE.md                     # SPM 使用指南
├── SPM_ANALYSIS.md                  # 项目分析报告
├── SPM_README.md                    # 本文件
└── iOS/
    ├── DoraemonKit/
    │   ├── Src/
    │   │   ├── Core/                # Core模块源代码
    │   │   ├── Logger/              # Logger模块源代码
    │   │   ├── GPS/                 # GPS模块源代码
    │   │   ├── MethodUseTime/       # Load模块源代码
    │   │   ├── Weex/                # Weex模块源代码
    │   │   ├── Database/            # Database模块源代码
    │   │   ├── MLeaksFinder/        # MLeaksFinder模块源代码
    │   │   └── MultiControl/        # MultiControl模块源代码
    │   └── Resource/                # Core模块资源文件
    └── DoKit/
        ├── Classes/
        │   ├── Core/                # 主库源代码
        │   ├── Foundation/          # Foundation模块源代码
        │   ├── CFoundation/         # CFoundation模块源代码
        │   └── EventSynthesize/     # EventSynthesize模块源代码
        └── Assets/                  # 主库资源文件
```

## 🚀 快速开始

### 1. 在 Xcode 中添加包依赖

1. 打开 Xcode 项目
2. 选择 `File` > `Add Packages...`
3. 输入仓库地址：`https://github.com/didi/DoraemonKit.git`
4. 选择版本或分支
5. 选择需要的产品

### 2. 基本使用

```swift
#if DEBUG
import DoraemonKit

// 默认安装
DoraemonManager.shareInstance().install()

// 或使用产品ID
DoraemonManager.shareInstance().install(withPid: "your-product-id")
#endif
```

## 📚 文档

- **SPM_GUIDE.md** - 详细的 SPM 集成和使用指南
- **SPM_ANALYSIS.md** - 项目结构和模块分析报告

## ⚠️ 注意事项

1. **仅用于 Debug 环境** - DoraemonKit 包含 hook 操作，不要带到线上
2. **外部依赖** - 某些模块需要额外的依赖（详见 SPM_GUIDE.md）
3. **Framework 依赖** - DoraemonKitLoad 模块需要手动添加 DoraemonLoadAnalyze.framework

## 🔗 相关链接

- 项目主页：https://www.dokit.cn
- GitHub：https://github.com/didi/DoraemonKit
- CocoaPods 版本：参考 iOS/README.md

## ✅ 验证状态

- ✅ Package.swift 语法验证通过
- ✅ 所有模块结构已定义
- ✅ 依赖关系已配置
- ✅ 资源文件路径已正确设置

## 📝 版本信息

- iOS 最低版本：9.0
- Swift 工具版本：5.5
- 当前版本：3.1.7（基于 podspec）

