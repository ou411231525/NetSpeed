import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitorViewModel
    @State private var showResetAlert = false

    var body: some View {
        NavigationStack {
            List {
                // Permissions Section
                Section {
                    PermissionRow(
                        icon: "bell.fill",
                        iconColor: .red,
                        title: "通知权限",
                        description: "用于实时活动和提醒",
                        isGranted: PermissionService.shared.notificationGranted
                    )

                    PermissionRow(
                        icon: "network",
                        iconColor: .blue,
                        title: "网络权限",
                        description: "监测网络流量",
                        isGranted: true
                    )

                    PermissionRow(
                        icon: "arrow.clockwise",
                        iconColor: .green,
                        title: "后台刷新",
                        description: "持续监测网速",
                        isGranted: PermissionService.shared.backgroundRefreshGranted
                    )
                } header: {
                    Text("权限管理")
                } footer: {
                    Text("点击未授权的权限项跳转到系统设置")
                }

                // Display Settings
                Section {
                    Toggle(isOn: $settings.showUploadSpeed) {
                        Label("显示上传速度", systemImage: "arrow.up")
                    }

                    Toggle(isOn: $settings.showDataUsage) {
                        Label("显示流量统计", systemImage: "chart.bar.fill")
                    }

                    Toggle(isOn: $settings.autoStartLiveActivity) {
                        Label("启动时开启实时显示", systemImage: "play.fill")
                    }

                    Picker(selection: $settings.speedUnit) {
                        Text("自动").tag(0)
                        Text("KB/s").tag(1)
                        Text("MB/s").tag(2)
                    } label: {
                        Label("速度单位", systemImage: "ruler")
                    }
                } header: {
                    Text("显示设置")
                }

                // Update Frequency
                Section {
                    Picker(selection: $settings.updateInterval) {
                        Text("0.5秒").tag(0.5)
                        Text("1秒").tag(1.0)
                        Text("2秒").tag(2.0)
                    } label: {
                        Label("刷新频率", systemImage: "clock")
                    }
                } header: {
                    Text("性能")
                } footer: {
                    Text("更快的刷新频率会消耗更多电量")
                }

                // Live Activity Settings
                Section {
                    Toggle(isOn: $settings.showOnLockScreen) {
                        Label("锁屏显示", systemImage: "lock.fill")
                    }

                    Toggle(isOn: $settings.showOnDynamicIsland) {
                        Label("灵动岛显示", systemImage: "capsule.portrait")
                    }

                    Toggle(isOn: $settings.showNetworkType) {
                        Label("显示网络类型", systemImage: "wifi")
                    }
                } header: {
                    Text("实时活动")
                } footer: {
                    Text("灵动岛功能仅支持 iPhone 14 Pro 及更新机型")
                }

                // Data Management
                Section {
                    Button {
                        showResetAlert = true
                    } label: {
                        Label("重置统计数据", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("数据管理")
                }

                // About Section
                Section {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("支持的iOS版本")
                        Spacer()
                        Text("iOS 16.1+")
                            .foregroundColor(.secondary)
                    }

                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("关于应用", systemImage: "info.circle")
                    }
                } header: {
                    Text("关于")
                }
            }
            .navigationTitle("设置")
            .alert("重置统计数据", isPresented: $showResetAlert) {
                Button("取消", role: .cancel) {}
                Button("重置", role: .destructive) {
                    networkMonitor.resetStatistics()
                }
            } message: {
                Text("确定要重置所有统计数据吗？此操作无法撤销。")
            }
        }
    }
}

// MARK: - Permission Row
struct PermissionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let isGranted: Bool

    var body: some View {
        Button {
            openSettings()
        } label: {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: isGranted ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isGranted ? .green : .red)
            }
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - About View
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // App Icon
                Image(systemName: "speedometer")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())

                VStack(spacing: 8) {
                    Text("NetSpeed")
                        .font(.largeTitle.bold())

                    Text("iOS网速监控应用")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(
                        icon: "bolt.fill",
                        title: "实时监测",
                        description: "每秒更新当前网络下载和上传速度"
                    )

                    FeatureRow(
                        icon: "capsule.portrait.fill",
                        title: "灵动岛显示",
                        description: "在灵动岛中实时显示网速"
                    )

                    FeatureRow(
                        icon: "lock.fill",
                        title: "锁屏显示",
                        description: "在锁屏界面查看网速信息"
                    )

                    FeatureRow(
                        icon: "chart.bar.fill",
                        title: "流量统计",
                        description: "记录每日流量使用情况"
                    )
                }
                .padding()

                Spacer()
            }
            .padding()
        }
        .navigationTitle("关于")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
        .environmentObject(NetworkMonitorViewModel())
}
