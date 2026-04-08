import UIKit
import UserNotifications
import ActivityKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Request notification permissions for Live Activities
        requestNotificationPermissions()

        // Check and update Live Activity if needed
        if #available(iOS 16.1, *) {
            LiveActivityService.shared.startLiveActivity()
        }

        return true
    }

    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            print("Notification permission granted: \(granted)")
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Re-check permissions when app comes to foreground
        PermissionService.shared.checkAllPermissions()

        // Restart network monitoring
        if #available(iOS 16.1, *) {
            LiveActivityService.shared.startLiveActivity()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Update Live Activity when entering background
        if #available(iOS 16.1, *) {
            LiveActivityService.shared.updateLiveActivity()
        }
    }
}
