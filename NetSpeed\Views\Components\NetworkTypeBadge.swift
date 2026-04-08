import SwiftUI

struct NetworkTypeBadge: View {
    let networkType: NetworkType

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.caption)

            Text(displayName)
                .font(.caption.bold())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(backgroundColor.opacity(0.15))
        .foregroundColor(backgroundColor)
        .clipShape(Capsule())
    }

    private var iconName: String {
        switch networkType {
        case .wifi:
            return "wifi"
        case .cellular5G:
            return "5g"
        case .cellular4G:
            return "4g.lte"
        case .cellular3G:
            return "3g"
        case .cellular:
            return "antenna.radiowaves.left.and.right"
        case .wired:
            return "cable.connector"
        case .none:
            return "wifi.slash"
        }
    }

    private var displayName: String {
        switch networkType {
        case .wifi:
            return "WiFi"
        case .cellular5G:
            return "5G"
        case .cellular4G:
            return "4G"
        case .cellular3G:
            return "3G"
        case .cellular:
            return "移动网络"
        case .wired:
            return "有线"
        case .none:
            return "无网络"
        }
    }

    private var backgroundColor: Color {
        switch networkType {
        case .wifi:
            return .blue
        case .cellular5G:
            return .purple
        case .cellular4G:
            return .green
        case .cellular3G:
            return .orange
        case .cellular:
            return .orange
        case .wired:
            return .gray
        case .none:
            return .red
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        NetworkTypeBadge(networkType: .wifi)
        NetworkTypeBadge(networkType: .cellular5G)
        NetworkTypeBadge(networkType: .cellular4G)
        NetworkTypeBadge(networkType: .cellular3G)
        NetworkTypeBadge(networkType: .none)
    }
}
