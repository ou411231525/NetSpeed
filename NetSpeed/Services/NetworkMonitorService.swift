import Foundation
import Network

class NetworkMonitorService {
    static let shared = NetworkMonitorService()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorService")

    var onNetworkChange: ((NWPath) -> Void)?

    private init() {}

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.onNetworkChange?(path)
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    func getCurrentPath() -> NWPath? {
        // Note: NWPathMonitor doesn't provide a way to get current path synchronously
        // This would require storing the last known path
        return nil
    }
}
