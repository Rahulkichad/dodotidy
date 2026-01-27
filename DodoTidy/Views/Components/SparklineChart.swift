import SwiftUI

/// A mini sparkline chart showing historical data points
struct SparklineChart: View {
    let data: [Double]
    let color: Color
    let showGradient: Bool

    init(data: [Double], color: Color = .dodoPrimary, showGradient: Bool = true) {
        self.data = data
        self.color = color
        self.showGradient = showGradient
    }

    private var normalizedData: [Double] {
        guard let maxVal = data.max(), let minVal = data.min(), maxVal > minVal else {
            return data.map { _ in 0.5 }
        }
        return data.map { ($0 - minVal) / (maxVal - minVal) }
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let stepX = width / CGFloat(max(data.count - 1, 1))

            ZStack {
                // Gradient fill
                if showGradient {
                    Path { path in
                        guard !normalizedData.isEmpty else { return }

                        path.move(to: CGPoint(x: 0, y: height))

                        for (index, value) in normalizedData.enumerated() {
                            let x = CGFloat(index) * stepX
                            let y = height - (CGFloat(value) * height * 0.8 + height * 0.1)

                            if index == 0 {
                                path.addLine(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }

                        path.addLine(to: CGPoint(x: width, y: height))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.3), color.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }

                // Line
                Path { path in
                    guard !normalizedData.isEmpty else { return }

                    for (index, value) in normalizedData.enumerated() {
                        let x = CGFloat(index) * stepX
                        let y = height - (CGFloat(value) * height * 0.8 + height * 0.1)

                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))

                // Current value dot
                if let lastValue = normalizedData.last {
                    let x = width
                    let y = height - (CGFloat(lastValue) * height * 0.8 + height * 0.1)

                    Circle()
                        .fill(color)
                        .frame(width: 4, height: 4)
                        .position(x: x, y: y)
                }
            }
        }
    }
}

/// Manager for tracking metric history
@Observable
final class MetricsHistoryManager {
    static let shared = MetricsHistoryManager()

    private(set) var cpuHistory: [Double] = []
    private(set) var memoryHistory: [Double] = []
    private(set) var diskHistory: [Double] = []

    private let maxDataPoints = 30

    private init() {}

    func addCPU(_ value: Double) {
        cpuHistory.append(value)
        if cpuHistory.count > maxDataPoints {
            cpuHistory.removeFirst()
        }
    }

    func addMemory(_ value: Double) {
        memoryHistory.append(value)
        if memoryHistory.count > maxDataPoints {
            memoryHistory.removeFirst()
        }
    }

    func addDisk(_ value: Double) {
        diskHistory.append(value)
        if diskHistory.count > maxDataPoints {
            diskHistory.removeFirst()
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SparklineChart(data: [20, 35, 28, 45, 52, 38, 42, 55, 48, 62], color: .dodoSuccess)
            .frame(width: 100, height: 30)

        SparklineChart(data: [70, 65, 72, 78, 75, 80, 82, 79, 85, 88], color: .dodoWarning)
            .frame(width: 100, height: 30)
    }
    .padding()
    .background(Color.dodoBackground)
}
