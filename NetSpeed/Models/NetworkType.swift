import Foundation

enum NetworkType: String, CaseIterable {
    case wifi = "WiFi"
    case cellular5G = "5G"
    case cellular4G = "4G"
    case cellular3G = "3G"
    case cellular = "Cellular"
    case wired = "Wired"
    case none = "No Connection"

    var iconName: String {
        switch self {
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

    var displayName: String {
        return self.rawValue
    }
}
