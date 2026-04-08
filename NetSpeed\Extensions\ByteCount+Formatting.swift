import Foundation

extension Int64 {
    var formattedBytes: String {
        ByteCountFormatter.string(fromByteCount: self, countStyle: .binary)
    }

    var formattedSpeed: String {
        let bytesPerSecond = Double(self)
        return SpeedFormatter.formatSpeed(bytesPerSecond)
    }
}

extension Double {
    var formattedSpeed: String {
        SpeedFormatter.formatSpeed(self)
    }

    var speedLevel: SpeedLevel {
        let mbps = self / (1024 * 1024)

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
