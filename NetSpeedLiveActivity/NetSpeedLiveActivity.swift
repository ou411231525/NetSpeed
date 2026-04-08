import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - Live Activity Attributes
struct NetSpeedLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var downloadSpeed: String
        var uploadSpeed: String
        var networkType: String
    }

    // No additional attributes needed
}

// MARK: - Live Activity Widget
struct NetSpeedLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NetSpeedLiveActivityAttributes.self) { context in
            // Lock Screen / Banner UI
            LockScreenView(state: context.state)
                .activityBackgroundTint(Color(.systemBackground))
                .activitySystemActionForegroundColor(Color.primary)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.green)
                        Text(context.state.downloadSpeed)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.blue)
                        Text(context.state.uploadSpeed)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Image(systemName: networkIcon(for: context.state.networkType))
                            .foregroundColor(.blue)
                        Text(context.state.networkType)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 4)
                }

                DynamicIslandExpandedRegion(.center) {
                    EmptyView()
                }
            } compactLeading: {
                // Compact Leading
                HStack(spacing: 2) {
                    Image(systemName: "arrow.down")
                        .foregroundColor(.green)
                        .font(.caption2)
                    Text(context.state.downloadSpeed)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.6)
                }
            } compactTrailing: {
                // Compact Trailing
                HStack(spacing: 2) {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.blue)
                        .font(.caption2)
                    Text(context.state.uploadSpeed)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.6)
                }
            } minimal: {
                // Minimal
                Image(systemName: "speedometer")
                    .foregroundColor(.blue)
            }
        }
    }

    private func networkIcon(for type: String) -> String {
        switch type {
        case "WiFi":
            return "wifi"
        case "5G":
            return "5g"
        case "4G":
            return "4g.lte"
        default:
            return "antenna.radiowaves.left.and.right"
        }
    }
}

// MARK: - Lock Screen View
struct LockScreenView: View {
    let state: NetSpeedLiveActivityAttributes.ContentState

    var body: some View {
        HStack(spacing: 24) {
            // Download
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(.green)
                    Text("下载")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(state.downloadSpeed)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            }

            Divider()
                .frame(height: 40)

            // Upload
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.blue)
                    Text("上传")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(state.uploadSpeed)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            }

            Spacer()

            // Network Type
            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: networkIcon(for: state.networkType))
                    .font(.title2)
                    .foregroundColor(.blue)

                Text(state.networkType)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }

    private func networkIcon(for type: String) -> String {
        switch type {
        case "WiFi":
            return "wifi"
        case "5G":
            return "5g"
        case "4G":
            return "4g.lte"
        default:
            return "antenna.radiowaves.left.and.right"
        }
    }
}

// MARK: - Preview
#if DEBUG
@available(iOS 17.0, *)
#Preview("Live Activity", as: .content, using: NetSpeedLiveActivityAttributes(
    startDate: Date(),
    endDate: Date().addingTimeInterval(3600),
    isSticky: false,
    content: "Network Activity"
)) {
    NetSpeedLiveActivity()
} contentStates: {
    NetSpeedLiveActivityAttributes.ContentState(
        downloadSpeed: "15.2 MB/s",
        uploadSpeed: "2.5 MB/s",
        networkType: "WiFi"
    )
}
#endif
