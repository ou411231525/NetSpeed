import Foundation
import ActivityKit

@available(iOS 16.1, *)
class LiveActivityService {
    static let shared = LiveActivityService()

    private var currentActivity: Activity<NetSpeedAttributes>?

    private init() {}

    // MARK: - Start Live Activity
    func startLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities are not enabled")
            return
        }

        // End any existing activity
        Task {
            for activity in Activity<NetSpeedAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }

        let attributes = NetSpeedAttributes()
        let initialState = NetSpeedAttributes.ContentState(
            downloadSpeed: "0 KB/s",
            uploadSpeed: "0 KB/s",
            networkType: "检测中..."
        )

        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: nil
            )
            currentActivity = activity
            print("Live Activity started: \(activity.id)")
        } catch {
            print("Error starting Live Activity: \(error)")
        }
    }

    // MARK: - Update Live Activity
    func updateLiveActivity(downloadSpeed: Double, uploadSpeed: Double, networkType: String) {
        guard let activity = currentActivity else {
            // Start if not exists
            startLiveActivity()
            return
        }

        let state = NetSpeedAttributes.ContentState(
            downloadSpeed: formatSpeed(downloadSpeed),
            uploadSpeed: formatSpeed(uploadSpeed),
            networkType: networkType
        )

        Task {
            await activity.update(
                ActivityContent(state: state, staleDate: Date.now + 2)
            )
        }
    }

    // MARK: - Stop Live Activity
    func stopLiveActivity() {
        guard let activity = currentActivity else { return }

        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
            currentActivity = nil
        }
    }

    // MARK: - Helper
    private func formatSpeed(_ bytesPerSecond: Double) -> String {
        if bytesPerSecond < 1024 {
            return String(format: "%.0f B/s", bytesPerSecond)
        } else if bytesPerSecond < 1024 * 1024 {
            return String(format: "%.1f KB/s", bytesPerSecond / 1024)
        } else {
            return String(format: "%.2f MB/s", bytesPerSecond / (1024 * 1024))
        }
    }
}

// MARK: - Live Activity Attributes
struct NetSpeedAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var downloadSpeed: String
        var uploadSpeed: String
        var networkType: String
    }

    // No additional attributes needed for now
}
