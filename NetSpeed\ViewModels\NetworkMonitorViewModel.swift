import Foundation
import Network
import Combine

class NetworkMonitorViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var downloadSpeed: Double = 0
    @Published var uploadSpeed: Double = 0
    @Published var networkType: NetworkType = .none
    @Published var isConnected: Bool = false

    // Statistics
    @Published var todayDownload: Int64 = 0
    @Published var todayUpload: Int64 = 0
    @Published var totalDownload: Int64 = 0
    @Published var totalUpload: Int64 = 0

    // MARK: - Private Properties
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var timer: Timer?
    private var previousBytesReceived: Int64 = 0
    private var previousBytesSent: Int64 = 0
    private var startTime: Date?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init() {
        setupMonitor()
        loadSavedStatistics()
    }

    deinit {
        stopMonitoring()
    }

    // MARK: - Setup
    private func setupMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.updateNetworkType(from: path)
                self?.isConnected = path.status == .satisfied
            }
        }
    }

    private func updateNetworkType(from path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            networkType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            // Note: iOS doesn't provide direct 5G/4G detection
            // This would require additional frameworks like CoreTelephony
            networkType = .cellular4G
        } else if path.usesInterfaceType(.wiredEthernet) {
            networkType = .wired
        } else {
            networkType = .none
        }
    }

    // MARK: - Public Methods
    func startMonitoring() {
        monitor.start(queue: queue)
        startTimer()
        startTime = Date()
        previousBytesReceived = 0
        previousBytesSent = 0

        // Initial read
        updateNetworkStats()
    }

    func stopMonitoring() {
        monitor.cancel()
        timer?.invalidate()
        timer = nil
    }

    func resetStatistics() {
        todayDownload = 0
        todayUpload = 0
        totalDownload = 0
        totalUpload = 0
        saveStatistics()
    }

    // MARK: - Private Methods
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateNetworkStats()
        }
    }

    private func updateNetworkStats() {
        // Get network interface statistics
        let (bytesReceived, bytesSent) = getNetworkBytes()

        if previousBytesReceived > 0 {
            let downloadDiff = bytesReceived - previousBytesReceived
            let uploadDiff = bytesSent - previousBytesSent

            DispatchQueue.main.async {
                // Update speeds (bytes per second)
                self.downloadSpeed = Double(max(0, downloadDiff))
                self.uploadSpeed = Double(max(0, uploadDiff))

                // Update statistics
                if downloadDiff > 0 {
                    self.todayDownload += downloadDiff
                    self.totalDownload += downloadDiff
                }
                if uploadDiff > 0 {
                    self.todayUpload += uploadDiff
                    self.totalUpload += uploadDiff
                }

                // Save periodically
                self.saveStatistics()
            }
        }

        previousBytesReceived = bytesReceived
        previousBytesSent = bytesSent
    }

    private func getNetworkBytes() -> (Int64, Int64) {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&ifaddr) == 0 else {
            return (0, 0)
        }

        defer { freeifaddrs(ifaddr) }

        var bytesReceived: Int64 = 0
        var bytesSent: Int64 = 0

        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }

            guard let info = ptr?.pointee else { continue }

            let name = String(cString: info.ifa_name)

            // Check for WiFi (en0) or cellular (pdp_ip)
            if name.hasPrefix("en") || name.hasPrefix("pdp_ip") {
                if let data = info.ifa_data {
                    let networkData = data.assumingMemoryBound(to: if_data.self)
                    bytesReceived += Int64(networkData.pointee.ifi_ibytes)
                    bytesSent += Int64(networkData.pointee.ifi_obytes)
                }
            }
        }

        return (bytesReceived, bytesSent)
    }

    // MARK: - Persistence
    private func saveStatistics() {
        let defaults = UserDefaults.standard
        defaults.set(todayDownload, forKey: "todayDownload")
        defaults.set(todayUpload, forKey: "todayUpload")
        defaults.set(totalDownload, forKey: "totalDownload")
        defaults.set(totalUpload, forKey: "totalUpload")

        // Save last update date
        defaults.set(Date(), forKey: "lastStatisticsDate")
    }

    private func loadSavedStatistics() {
        let defaults = UserDefaults.standard

        // Check if it's a new day
        if let lastDate = defaults.object(forKey: "lastStatisticsDate") as? Date {
            if !Calendar.current.isDateInToday(lastDate) {
                // Reset daily statistics for new day
                defaults.set(Int64(0), forKey: "todayDownload")
                defaults.set(Int64(0), forKey: "todayUpload")
            }
        }

        todayDownload = Int64(defaults.integer(forKey: "todayDownload"))
        todayUpload = Int64(defaults.integer(forKey: "todayUpload"))
        totalDownload = Int64(defaults.integer(forKey: "totalDownload"))
        totalUpload = Int64(defaults.integer(forKey: "totalUpload"))
    }
}
