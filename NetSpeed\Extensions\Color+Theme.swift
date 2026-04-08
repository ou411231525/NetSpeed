import SwiftUI

extension Color {
    // MARK: - Theme Colors
    static let netspeedPrimary = Color("Primary", bundle: nil)
    static let netspeedSecondary = Color("Secondary", bundle: nil)
    static let netspeedAccent = Color("Accent", bundle: nil)

    // MARK: - Speed Level Colors
    static let speedSlow = Color.red
    static let speedMedium = Color.orange
    static let speedFast = Color.blue
    static let speedVeryFast = Color.green

    // MARK: - Background Colors
    static let cardBackground = Color(.systemBackground)
    static let cardBackgroundSecondary = Color(.secondarySystemBackground)

    // MARK: - Dynamic Colors
    static func speedColor(for bytesPerSecond: Double) -> Color {
        let mbps = bytesPerSecond / (1024 * 1024)

        if mbps < 1 {
            return .speedSlow
        } else if mbps < 5 {
            return .speedMedium
        } else if mbps < 20 {
            return .speedFast
        } else {
            return .speedVeryFast
        }
    }

    // MARK: - Hex Initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
