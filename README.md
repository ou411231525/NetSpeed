# NetSpeed - iOS网速监控应用

<div align="center">
  <img src="https://img.shields.io/badge/iOS-16.1+-blue.svg" alt="iOS Version">
  <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift Version">
  <img src="https://img.shields.io/badge/Platform-iPhone-green.svg" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
</div>

---

## 应用介绍

NetSpeed 是一款类似小米手机"状态栏显示网速"功能的iOS应用。它能够：

- 实时监测 - 每秒更新当前网络下载和上传速度
- 灵动岛显示 - 在iPhone 14 Pro及更新机型的灵动岛上显示网速
- 锁屏显示 - 在锁屏界面实时查看网速
- 流量统计 - 记录每日流量使用情况
- 精美界面 - 现代化的UI设计，支持深色模式

## 功能特点

### 1. 实时网速监测
- 下载速度监测
- 上传速度监测
- 网络类型识别 (WiFi/5G/4G/3G)
- 速度单位自动切换 (B/s, KB/s, MB/s, GB/s)

### 2. 速度颜色分级
- 0-1 MB/s: 慢
- 1-5 MB/s: 中
- 5-20 MB/s: 快
- 20+ MB/s: 极快

### 3. 权限管理
每次打开应用自动检测权限状态：
- 通知权限 - 用于实时活动
- 后台刷新 - 持续监测
- 网络访问 - 流量监测

## 支持的设备

| 设备类型 | 支持情况 |
|---------|---------|
| iPhone 8 - 13 | 完全支持 |
| iPhone 14 Pro/Pro Max | 灵动岛支持 |
| iPhone 14/Plus | 完全支持 |
| iPhone 15 系列 | 完全支持 |
| iPhone 16 系列 | 完全支持 |

| iOS版本 | 支持情况 |
|---------|---------|
| iOS 16.1 | 基础功能 |
| iOS 17.0+ | 完整功能 |
| iOS 18.0+ | 完整功能 |

## 技术架构

```
NetSpeed/
├── App/                    # 应用入口
├── Views/                  # 视图层
├── ViewModels/             # 视图模型
├── Models/                 # 数据模型
├── Services/               # 服务层
├── Extensions/             # 扩展
└── Resources/              # 资源文件

NetSpeedWidget/             # 桌面小组件扩展
NetSpeedLiveActivity/       # 实时活动扩展
```

## 构建项目

### 环境要求
- macOS 12.0+
- Xcode 15.0+
- XcodeGen

### 构建步骤

1. 安装 XcodeGen
```bash
brew install xcodegen
```

2. 生成 Xcode 项目
```bash
xcodegen generate
```

3. 打开项目
```bash
open NetSpeed.xcodeproj
```

4. 选择模拟器并运行

## 权限说明

| 权限 | 用途 | 是否必需 |
|-----|------|---------|
| 通知权限 | 实时活动显示 | 建议开启 |
| 后台刷新 | 持续监测 | 建议开启 |
| 网络权限 | 监测流量 | 必须 |

## 注意事项

1. iOS系统限制，无法直接修改系统状态栏
2. 灵动岛功能仅支持 iPhone 14 Pro 及更新机型
3. 实时活动需要 iOS 16.1+
4. 应用使用 NetworkExtension 框架监测流量

## 许可证

本项目采用 MIT 许可证。
