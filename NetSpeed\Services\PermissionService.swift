import Foundation
import UserNotifications
import UIKit

class PermissionService {
    static let shared = PermissionService()

    // MARK: - Permission Status
    private(set) var notificationGranted: Bool = false
    private(set) var backgroundRefreshGranted: Bool = false
    private(set) var allPermissionsGranted: Bool = false

    private init() {
        checkAllPermissions()
    }

    // MARK: - Check All Permissions
    func checkAllPermissions() {
        checkNotificationPermission()
        checkBackgroundRefreshPermission()
        updateOverallStatus()
    }

    // MARK: - Check & Request Permissions
    func checkAndRequestPermissions() async -> (granted: Bool, message: String) {
        checkAllPermissions()

        var missingPermissions: [String] = []

        if !notificationGranted {
            missingPermissions.append("通知权限")
        }

        if missingPermissions.isEmpty {
            return (true, "所有权限已授权")
        }

        let message = "以下权限未授权：\(missingPermissions.joined(separator: "、"))。部分功能可能无法正常使用。"

        return (false, message)
    }

    // MARK: - Notification Permission
    private func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationGranted = settings.authorizationStatus == .authorized
            }
        }
    }

    func requestNotificationPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await MainActor.run {
                self.notificationGranted = granted
                self.updateOverallStatus()
            }
            return granted
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    // MARK: - Background Refresh Permission
    private func checkBackgroundRefreshPermission() {
        DispatchQueue.main.async {
            // iOS doesn't provide a direct API to check background refresh status
            // We can only check if the app is in the enabled list
            self.backgroundRefreshGranted = UIApplication.shared.backgroundRefreshStatus == .available
        }
    }

    // MARK: - Update Overall Status
    private func updateOverallStatus() {
        allPermissionsGranted = notificationGranted && backgroundRefreshGranted
    }

    // MARK: - Open Settings
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Show Permission Alert
    func showPermissionAlert(on viewController: UIViewController) {
        let alert = UIAlertController(
            title: "权限提醒",
            message: "部分权限未授权，部分功能可能无法正常使用。",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            self.openSettings()
        })

        alert.addAction(UIAlertAction(title: "稍后", style: .cancel))

        viewController.present(alert, animated: true)
    }
}
