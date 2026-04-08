import SwiftUI

@main
struct NetSpeedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var networkMonitor = NetworkMonitorViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
                .environmentObject(settingsViewModel)
                .onAppear {
                    PermissionService.shared.checkAllPermissions()
                }
        }
    }
}
