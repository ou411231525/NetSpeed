import SwiftUI

struct SpeedCard: View {
    let downloadSpeed: Double
    let uploadSpeed: Double
    let networkType: NetworkType

    @State private var animatedDownloadSpeed: Double = 0
    @State private var animatedUploadSpeed: Double = 0

    var body: some View {
        VStack(spacing: 20) {
            // Download Speed
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(.green)
                    Text("下载")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text(formatSpeed(downloadSpeed))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(speedColor(for: downloadSpeed))
                    .contentTransition(.numericText())

                Text(unitString(for: downloadSpeed))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()
                .padding(.horizontal)

            // Upload Speed
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.blue)
                    Text("上传")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text(formatSpeed(uploadSpeed))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(speedColor(for: uploadSpeed))
                    .contentTransition(.numericText())

                Text(unitString(for: uploadSpeed))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        )
        .onChange(of: downloadSpeed) { _, newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                animatedDownloadSpeed = newValue
            }
        }
        .onChange(of: uploadSpeed) { _, newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                animatedUploadSpeed = newValue
            }
        }
    }

    // MARK: - Speed Formatting
    private func formatSpeed(_ bytesPerSecond: Double) -> String {
        if bytesPerSecond < 1024 {
            return String(format: "%.0f", bytesPerSecond)
        } else if bytesPerSecond < 1024 * 1024 {
            return String(format: "%.1f", bytesPerSecond / 1024)
        } else {
            return String(format: "%.2f", bytesPerSecond / (1024 * 1024))
        }
    }

    private func unitString(for bytesPerSecond: Double) -> String {
        if bytesPerSecond < 1024 {
            return "B/s"
        } else if bytesPerSecond < 1024 * 1024 {
            return "KB/s"
        } else {
            return "MB/s"
        }
    }

    // MARK: - Speed Color
    private func speedColor(for bytesPerSecond: Double) -> Color {
        let mbps = bytesPerSecond / (1024 * 1024)

        if mbps < 1 {
            return .red
        } else if mbps < 5 {
            return .orange
        } else if mbps < 20 {
            return .blue
        } else {
            return .green
        }
    }
}

#Preview {
    SpeedCard(
        downloadSpeed: 15.5 * 1024 * 1024,
        uploadSpeed: 2.3 * 1024 * 1024,
        networkType: .wifi
    )
    .padding()
}
