import SwiftUI
import ActivityKit

struct MainView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitorViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @State private var showPermissionAlert = false
    @State private var permissionMessage = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Permission Warning Banner
                    if !PermissionService.shared.allPermissionsGranted {
                        PermissionWarningBanner(
                            message: "部分权限未授权，可能影响功能",
                            action: {
                                showPermissionAlert = true
                            }
                        )
                    }

                    // Main Speed Display
                    SpeedCard(
                        downloadSpeed: networkMonitor.downloadSpeed,
                        uploadSpeed: networkMonitor.uploadSpeed,
                        networkType: networkMonitor.networkType
                    )

                    // Network Type Badge
                    NetworkTypeBadge(networkType: networkMonitor.networkType)

                    // Live Activity Control
                    LiveActivityControl()

                    // Statistics Section
                    StatisticsSection(networkMonitor: networkMonitor)

                    // Tips Section
                    TipsSection()
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("NetSpeed")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        networkMonitor.startMonitoring()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .alert("权限提醒", isPresented: $showPermissionAlert) {
                Button("去设置") {
                    openAppSettings()
                }
                Button("稍后", role: .cancel) {}
            } message: {
                Text(permissionMessage)
            }
            .onAppear {
                networkMonitor.startMonitoring()
                checkPermissions()
            }
        }
    }

    private func checkPermissions() {
        Task {
            let (granted, message) = await PermissionService.shared.checkAndRequestPermissions()
            if !granted {
                permissionMessage = message
                showPermissionAlert = true
            }
        }
    }

    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Permission Warning Banner
struct PermissionWarningBanner: View {
    let message: String
    let action: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()

            Button("检查") {
                action()
            }
            .font(.subheadline.bold())
            .foregroundColor(.blue)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Live Activity Control
struct LiveActivityControl: View {
    @EnvironmentObject var networkMonitor: NetworkMonitorViewModel
    @State private var isLiveActivityEnabled = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("实时显示")
                .font(.headline)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("灵动岛/锁屏显示")
                        .font(.subheadline)
                    Text("在灵动岛和锁屏界面显示当前网速")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Toggle("", isOn: $isLiveActivityEnabled)
                    .onChange(of: isLiveActivityEnabled) { _, newValue in
                        if newValue {
                            startLiveActivity()
                        } else {
                            stopLiveActivity()
                        }
                    }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }

    private func startLiveActivity() {
        if #available(iOS 16.1, *) {
            LiveActivityService.shared.startLiveActivity()
        }
    }

    private func stopLiveActivity() {
        if #available(iOS 16.1, *) {
            LiveActivityService.shared.stopLiveActivity()
        }
    }
}

// MARK: - Statistics Section
struct StatisticsSection: View {
    @ObservedObject var networkMonitor: NetworkMonitorViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("流量统计")
                .font(.headline)

            HStack(spacing: 12) {
                StatCard(
                    title: "今日下载",
                    value: formatBytes(networkMonitor.todayDownload),
                    icon: "arrow.down.circle.fill",
                    color: .green
                )

                StatCard(
                    title: "今日上传",
                    value: formatBytes(networkMonitor.todayUpload),
                    icon: "arrow.up.circle.fill",
                    color: .blue
                )
            }
        }
    }

    private func formatBytes(_ bytes: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .binary)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(value)
                .font(.title3.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Tips Section
struct TipsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("使用提示")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                TipRow(
                    icon: "hand.tap.fill",
                    text: "开启实时显示后，网速会显示在灵动岛和锁屏界面"
                )
                TipRow(
                    icon: "wifi",
                    text: "确保已开启通知权限以使用实时活动功能"
                )
                TipRow(
                    icon: "arrow.clockwise",
                    text: "上拉刷新可重新检测网络状态"
                )
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
}

// MARK: - Tip Row
struct TipRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(NetworkMonitorViewModel())
        .environmentObject(SettingsViewModel())
}
