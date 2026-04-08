import Foundation

struct NetworkSpeed {
    let bytesPerSecond: Double
    let timestamp: Date

    var formattedSpeed: String {
        return SpeedFormatter.formatSpeed(bytesPerSecond)
    }

    var speedLevel: SpeedLevel {
        let mbps = bytesPerSecond / (1024 * 1024)

        if mbps < 1 {
            return .slow
        } else if mbps < 5 {
            return .medium
        } else if mbps < 20 {
            return .fast
        } else {
            return .veryFast
        }
    }
}

enum SpeedLevel {
    case slow
    case medium
    case fast
    case veryFast

    var description: String {
        switch self {
        case .slow:
            return "慢"
        case .medium:
            return "中"
        case .fast:
            return "快"
        case .veryFast:
            return "极快"
        }
    }
}

class SpeedFormatter {
    static func formatSpeed(_ bytesPerSecond: Double) -> String {
        if bytesPerSecond < 1024 {
            return String(format: "%.0f B/s", bytesPerSecond)
        } else if bytesPerSecond < 1024 * 1024 {
            return String(format: "%.1f KB/s", bytesPerSecond / 1024)
        } else if bytesPerSecond < 1024 * 1024 * 1024 {
            return String(format: "%.2f MB/s", bytesPerSecond / (1024 * 1024))
        } else {
            return String(format: "%.2f GB/s", bytesPerSecond / (1024 * 1024 * 1024))
        }
    }

    static func formatBytes(_ bytes: Int64) -> String {
        if bytes < 1024 {
            return "\(bytes) B"
        } else if bytes < 1024 * 1024 {
            return String(format: "%.1f KB", Double(bytes) / 1024)
        } else if bytes < 1024 * 1024 * 1024 {
            return String(format: "%.2f MB", Double(bytes) / (1024 * 1024))
        } else {
            return String(format: "%.2f GB", Double(bytes) / (1024 * 1024 * 1024))
        }
    }
}
