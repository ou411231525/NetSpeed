# NetSpeed - iOS网速监控应用规格文档

## 1. 项目概述

- **项目名称**: NetSpeed
- **Bundle Identifier**: com.netspeed.monitor
- **Core Functionality**: 实时监测并显示当前网络下载/上传速度，类似于小米手机状态栏网速显示功能
- **目标用户**: iOS设备用户，尤其是iPhone用户
- **iOS版本支持**: iOS 16.1+ (支持Live Activities)，覆盖iPhone 8及更新机型
- **开发框架**: Swift 5.9+, SwiftUI, UIKit

## 2. UI/UX规格

### 屏幕结构

#### 2.1 主要界面
- **主屏幕 (MainView)**: 显示实时网速、流量统计
- **设置屏幕 (SettingsView)**: 应用设置、权限管理
- **使用说明屏幕 (GuideView)**: 功能介绍和使用指南

#### 2.2 导航结构
- TabView 底部导航 (主屏幕 | 设置)
- NavigationStack 内部导航

### 视觉设计

#### 2.3 色彩系统
```
Primary Color: #007AFF (iOS系统蓝)
Secondary Color: #34C759 (绿色-网速快)
Accent Color: #FF9500 (橙色-中速)
Warning Color: #FF3B30 (红色-慢速/错误)
Background Light: #F2F2F7
Background Dark: #1C1C1E
Text Primary: #000000 (Light) / #FFFFFF (Dark)
Text Secondary: #8E8E93
```

#### 2.4 网速颜色分级
- 0-1 MB/s: 红色 (#FF3B30)
- 1-5 MB/s: 橙色 (#FF9500)
- 5-20 MB/s: 蓝色 (#007AFF)
- 20+ MB/s: 绿色 (#34C759)

#### 2.5 排版系统
- 标题: SF Pro Display Bold, 28pt
- 大数字(网速): SF Pro Rounded Bold, 64pt
- 正文: SF Pro Text Regular, 17pt
- 辅助文字: SF Pro Text Regular, 13pt

#### 2.6 间距系统 (8pt Grid)
- 页面边距: 16pt
- 卡片间距: 12pt
- 元素间距: 8pt
- 图标大小: 24pt

### 组件设计

#### 2.7 速度显示卡片
- 圆角: 20px
- 背景: 玻璃态效果 (Blur + 半透明)
- 阴影: 0 4px 20px rgba(0,0,0,0.1)
- 悬停效果: scale(1.02), 0.2s ease-out

#### 2.8 动画效果
- 速度数字变化: 0.3s ease-in-out
- 颜色过渡: 0.5s linear
- 页面切换: 默认iOS系统动画

## 3. 功能规格

### 3.1 核心功能

#### 网速监测
- **下载速度监测**: 实时监测网络下载速度
- **上传速度监测**: 实时监测网络上传速度
- **刷新频率**: 每1秒更新一次
- **数据来源**: NetworkExtension框架

#### 速度单位
- 自动切换 B/s, KB/s, MB/s, GB/s
- 小数点后2位

### 3.2 权限管理

#### 必需权限
1. **网络权限 (Network)**: 监测网络流量 (Info.plist配置)
2. **通知权限 (Notifications)**: 实时活动通知 (iOS 16.1+)
3. **后台刷新 (Background Modes)**: 持续监测

#### 权限检测逻辑
```swift
// 每次启动检测
1. 检查通知权限 - 如果未授权，显示提示
2. 检查实时活动权限 - 如果未授权，显示提示
3. 检查后台刷新权限 - 如果未授权，显示提示
```

### 3.3 实时活动 (Live Activities)

#### 锁屏界面显示
- 显示当前下载/上传速度
- 显示网络类型 (5G/4G/WiFi)
- 更新频率: 每1秒

#### 灵动岛 (Dynamic Island)
- 紧凑模式: 显示下载速度
- 扩展模式: 下载+上传速度
- 最低支持: iPhone 14 Pro (iOS 16.1)

### 3.4 桌面小组件

#### Small Widget (2x2)
- 显示当前网速
- 颜色表示速度等级

#### Medium Widget (4x2)
- 下载/上传速度
- 网络类型

### 3.5 数据统计

#### 今日流量统计
- 今日已用流量
- 开启计时器后的流量

#### 历史统计 (可选)
- 存储最近7天数据
- 饼图展示

## 4. 技术架构

### 4.1 项目结构
```
NetSpeed/
├── App/
│   ├── NetSpeedApp.swift
│   └── AppDelegate.swift
├── Views/
│   ├── MainView.swift
│   ├── SettingsView.swift
│   ├── GuideView.swift
│   └── Components/
│       ├── SpeedCard.swift
│       ├── NetworkTypeBadge.swift
│       └── PermissionAlert.swift
├── ViewModels/
│   ├── NetworkMonitorViewModel.swift
│   └── SettingsViewModel.swift
├── Models/
│   ├── NetworkSpeed.swift
│   └── NetworkType.swift
├── Services/
│   ├── NetworkMonitorService.swift
│   ├── PermissionService.swift
│   └── LiveActivityService.swift
├── Extensions/
│   ├── Color+Theme.swift
│   └── ByteCount+Formatting.swift
├── Resources/
│   ├── Assets.xcassets
│   └── Info.plist
├── NetSpeedWidget/
│   ├── NetSpeedWidget.swift
│   └── NetSpeedWidgetBundle.swift
└── NetSpeedLiveActivity/
    ├── NetSpeedLiveActivity.swift
    └── NetSpeedLiveActivityBundle.swift
```

### 4.2 依赖管理
- **Swift Package Manager (SPM)**
- 无外部依赖，使用原生框架

### 4.3 目标设备支持
```
支持的设备:
- iPhone 8, 8 Plus
- iPhone X, XR, XS, XS Max
- iPhone 11, 11 Pro, 11 Pro Max
- iPhone 12 mini, 12, 12 Pro, 12 Pro Max
- iPhone 13 mini, 13, 13 Pro, 13 Pro Max
- iPhone 14, 14 Plus, 14 Pro, 14 Pro Max
- iPhone 15, 15 Plus, 15 Pro, 15 Pro Max
- iPhone 16, 16 Plus, 16 Pro, 16 Pro Max

支持的iOS版本:
- iOS 16.1+ (Live Activities必需)
- 推荐 iOS 17.0+ (完整功能)
```

### 4.4 Info.plist 配置
```xml
NSLocalNetworkUsageDescription - 局域网访问
UIBackgroundModes - fetch, processing, remote-notification
NSSupportsLiveActivities - YES
```

## 5. 错误处理

### 5.1 网络错误
- 无网络连接: 显示"无网络连接"
- 网络切换: 自动重新检测

### 5.2 权限错误
- 权限被拒绝: 弹出引导到设置的对话框
- 部分权限缺失: 降级到基础模式

## 6. GitHub Actions CI/CD

### 6.1 自动编译
- 推送到main分支自动触发
- 使用 Xcode 15+ 构建
- 输出 .ipa 文件

### 6.2 构建矩阵
- iOS 16.1
- iOS 17.0
- iPhone 14 Pro (灵动岛设备)
- iPhone 13 (普通设备)

## 7. 发布流程

1. 代码推送到GitHub
2. GitHub Actions自动编译
3. 生成TestFlight/AdHoc安装包
4. 用户通过链接安装
