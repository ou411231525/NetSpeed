import WidgetKit
import SwiftUI

// MARK: - Widget Entry
struct NetSpeedWidgetEntry: TimelineEntry {
    let date: Date
    let downloadSpeed: String
    let uploadSpeed: String
    let networkType: String
}

// MARK: - Widget Provider
struct NetSpeedWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> NetSpeedWidgetEntry {
        NetSpeedWidgetEntry(
            date: Date(),
            downloadSpeed: "0 KB/s",
            uploadSpeed: "0 KB/s",
            networkType: "检测中"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (NetSpeedWidgetEntry) -> Void) {
        let entry = NetSpeedWidgetEntry(
            date: Date(),
            downloadSpeed: "15.2 MB/s",
            uploadSpeed: "2.5 MB/s",
            networkType: "WiFi"
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NetSpeedWidgetEntry>) -> Void) {
        // Read data from shared UserDefaults
        let defaults = UserDefaults(suiteName: "group.com.netspeed.monitor")

        let downloadSpeed = defaults?.string(forKey: "widgetDownloadSpeed") ?? "0 KB/s"
        let uploadSpeed = defaults?.string(forKey: "widgetUploadSpeed") ?? "0 KB/s"
        let networkType = defaults?.string(forKey: "widgetNetworkType") ?? "未知"

        let entry = NetSpeedWidgetEntry(
            date: Date(),
            downloadSpeed: downloadSpeed,
            uploadSpeed: uploadSpeed,
            networkType: networkType
        )

        // Update every minute
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Widget View
struct NetSpeedWidgetEntryView: View {
    var entry: NetSpeedWidgetProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Small Widget
struct SmallWidgetView: View {
    let entry: NetSpeedWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "speedometer")
                    .foregroundColor(.blue)
                Text("网速")
                    .font(.caption.bold())
            }

            Spacer()

            Text(entry.downloadSpeed)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.5)

            Text(entry.networkType)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Medium Widget
struct MediumWidgetView: View {
    let entry: NetSpeedWidgetEntry

    var body: some View {
        HStack(spacing: 20) {
            // Download
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(.green)
                    Text("下载")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(entry.downloadSpeed)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
            }

            Divider()

            // Upload
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.blue)
                    Text("上传")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(entry.uploadSpeed)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
            }

            Spacer()

            // Network Type
            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: networkIcon(for: entry.networkType))
                    .font(.title)
                    .foregroundColor(.blue)

                Text(entry.networkType)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
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

// MARK: - Widget Configuration
struct NetSpeedWidget: Widget {
    let kind: String = "NetSpeedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NetSpeedWidgetProvider()) { entry in
            NetSpeedWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("网速监控")
        .description("实时显示当前网络下载和上传速度")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview
#if DEBUG
@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    NetSpeedWidget()
} timeline: {
    NetSpeedWidgetEntry(
        date: Date(),
        downloadSpeed: "15.2 MB/s",
        uploadSpeed: "2.5 MB/s",
        networkType: "WiFi"
    )
}

@available(iOS 17.0, *)
#Preview(as: .systemMedium) {
    NetSpeedWidget()
} timeline: {
    NetSpeedWidgetEntry(
        date: Date(),
        downloadSpeed: "15.2 MB/s",
        uploadSpeed: "2.5 MB/s",
        networkType: "WiFi"
    )
}
#endif
