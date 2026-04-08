import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitorViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            MainView()
                .tabItem {
                    Label("网速", systemImage: "speedometer")
                }
                .tag(0)

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
                .tag(1)
        }
        .tint(.blue)
        .onAppear {
            // Check permissions on appear
            checkPermissions()
        }
        .onChange(of: selectedTab) { _, _ in
            // Refresh data when switching tabs
            networkMonitor.startMonitoring()
        }
    }

    private func checkPermissions() {
        Task {
            await PermissionService.shared.checkAndRequestPermissions()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NetworkMonitorViewModel())
        .environmentObject(SettingsViewModel())
}
