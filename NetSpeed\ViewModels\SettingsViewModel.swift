import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    // MARK: - Display Settings
    @Published var showUploadSpeed: Bool {
        didSet {
            UserDefaults.standard.set(showUploadSpeed, forKey: "showUploadSpeed")
        }
    }

    @Published var showDataUsage: Bool {
        didSet {
            UserDefaults.standard.set(showDataUsage, forKey: "showDataUsage")
        }
    }

    @Published var autoStartLiveActivity: Bool {
        didSet {
            UserDefaults.standard.set(autoStartLiveActivity, forKey: "autoStartLiveActivity")
        }
    }

    @Published var speedUnit: Int {
        didSet {
            UserDefaults.standard.set(speedUnit, forKey: "speedUnit")
        }
    }

    // MARK: - Live Activity Settings
    @Published var showOnLockScreen: Bool {
        didSet {
            UserDefaults.standard.set(showOnLockScreen, forKey: "showOnLockScreen")
        }
    }

    @Published var showOnDynamicIsland: Bool {
        didSet {
            UserDefaults.standard.set(showOnDynamicIsland, forKey: "showOnDynamicIsland")
        }
    }

    @Published var showNetworkType: Bool {
        didSet {
            UserDefaults.standard.set(showNetworkType, forKey: "showNetworkType")
        }
    }

    // MARK: - Performance Settings
    @Published var updateInterval: Double {
        didSet {
            UserDefaults.standard.set(updateInterval, forKey: "updateInterval")
        }
    }

    // MARK: - Initialization
    init() {
        let defaults = UserDefaults.standard

        // Display Settings
        self.showUploadSpeed = defaults.object(forKey: "showUploadSpeed") as? Bool ?? true
        self.showDataUsage = defaults.object(forKey: "showDataUsage") as? Bool ?? true
        self.autoStartLiveActivity = defaults.object(forKey: "autoStartLiveActivity") as? Bool ?? false
        self.speedUnit = defaults.object(forKey: "speedUnit") as? Int ?? 0

        // Live Activity Settings
        self.showOnLockScreen = defaults.object(forKey: "showOnLockScreen") as? Bool ?? true
        self.showOnDynamicIsland = defaults.object(forKey: "showOnDynamicIsland") as? Bool ?? true
        self.showNetworkType = defaults.object(forKey: "showNetworkType") as? Bool ?? true

        // Performance Settings
        self.updateInterval = defaults.object(forKey: "updateInterval") as? Double ?? 1.0
    }

    // MARK: - Methods
    func resetToDefaults() {
        showUploadSpeed = true
        showDataUsage = true
        autoStartLiveActivity = false
        speedUnit = 0
        showOnLockScreen = true
        showOnDynamicIsland = true
        showNetworkType = true
        updateInterval = 1.0
    }
}
