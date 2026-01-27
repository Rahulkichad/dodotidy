import SwiftUI

// MARK: - Animated Loading Views

/// Animated loading view for the Cleaner - shows files going into trash
struct CleanerLoadingView: View {
    @State private var fileOffsets: [CGFloat] = [0, 0, 0]
    @State private var fileOpacities: [Double] = [1, 1, 1]
    @State private var trashScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Trash can
                Image(systemName: "trash")
                    .font(.system(size: 56))
                    .foregroundColor(.dodoPrimary)
                    .scaleEffect(trashScale)

                // Animated files
                ForEach(0..<3, id: \.self) { index in
                    Image(systemName: "doc.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.dodoTextTertiary)
                        .offset(x: CGFloat(index - 1) * 20, y: fileOffsets[index] - 60)
                        .opacity(fileOpacities[index])
                }
            }
            .frame(height: 100)

            Text("Scanning for cleanable items...")
                .font(.dodoBody)
                .foregroundColor(.dodoTextSecondary)

            ProgressView()
                .scaleEffect(0.8)
        }
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        // Animate each file with delay
        for index in 0..<3 {
            let delay = Double(index) * 0.3

            withAnimation(.easeIn(duration: 0.6).delay(delay).repeatForever(autoreverses: false)) {
                fileOffsets[index] = 80
                fileOpacities[index] = 0
            }
        }

        // Pulse trash can
        withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
            trashScale = 1.1
        }
    }
}

/// Animated loading view for the Analyzer - shows pie chart filling
struct AnalyzerLoadingView: View {
    @State private var rotation: Double = 0
    @State private var fillAmount: CGFloat = 0

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.dodoBackgroundTertiary, lineWidth: 8)
                    .frame(width: 80, height: 80)

                // Animated arc
                Circle()
                    .trim(from: 0, to: fillAmount)
                    .stroke(
                        AngularGradient(
                            colors: [.dodoPrimary, .dodoInfo, .dodoWarning, .dodoPrimary],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(rotation - 90))

                // Center icon
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.dodoPrimary)
            }

            Text("Analyzing disk usage...")
                .font(.dodoBody)
                .foregroundColor(.dodoTextSecondary)

            ProgressView()
                .scaleEffect(0.8)
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                fillAmount = 0.75
            }
        }
    }
}

/// Animated loading view for the Optimizer - shows lightning bolts
struct OptimizerLoadingView: View {
    @State private var boltOpacities: [Double] = [0.3, 0.3, 0.3]
    @State private var boltScales: [CGFloat] = [0.8, 0.8, 0.8]

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                ForEach(0..<3, id: \.self) { index in
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.dodoWarning)
                        .opacity(boltOpacities[index])
                        .scaleEffect(boltScales[index])
                }
            }
            .frame(height: 60)

            Text("Analyzing system for optimizations...")
                .font(.dodoBody)
                .foregroundColor(.dodoTextSecondary)

            ProgressView()
                .scaleEffect(0.8)
        }
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        for index in 0..<3 {
            let delay = Double(index) * 0.2

            withAnimation(.easeInOut(duration: 0.5).delay(delay).repeatForever(autoreverses: true)) {
                boltOpacities[index] = 1.0
                boltScales[index] = 1.2
            }
        }
    }
}

/// Animated loading view for Apps - shows app icons
struct AppsLoadingView: View {
    @State private var bounceOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.dodoBackgroundTertiary)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "app.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.dodoTextTertiary)
                        )
                        .offset(y: index % 2 == 0 ? bounceOffset : -bounceOffset)
                }
            }

            Text("Loading applications...")
                .font(.dodoBody)
                .foregroundColor(.dodoTextSecondary)

            ProgressView()
                .scaleEffect(0.8)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                bounceOffset = -8
            }
        }
    }
}

/// Animated loading view for Dashboard - shows metrics being collected
struct DashboardLoadingView: View {
    @State private var pulseScale: CGFloat = 1.0
    @State private var ringProgress: CGFloat = 0

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Outer ring
                Circle()
                    .stroke(Color.dodoBackgroundTertiary, lineWidth: 4)
                    .frame(width: 80, height: 80)

                // Animated ring
                Circle()
                    .trim(from: 0, to: ringProgress)
                    .stroke(Color.dodoPrimary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))

                // Center icon
                Image(systemName: "gauge.with.needle")
                    .font(.system(size: 28))
                    .foregroundColor(.dodoPrimary)
                    .scaleEffect(pulseScale)
            }

            Text("Collecting system metrics...")
                .font(.dodoBody)
                .foregroundColor(.dodoTextSecondary)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                pulseScale = 1.15
            }
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                ringProgress = 0.8
            }
        }
    }
}

// MARK: - Success Animation

/// Celebration animation for successful operations
struct SuccessAnimation: View {
    @State private var checkmarkScale: CGFloat = 0
    @State private var checkmarkOpacity: Double = 0
    @State private var ringScale: CGFloat = 0.5
    @State private var ringOpacity: Double = 1

    let onComplete: () -> Void

    var body: some View {
        ZStack {
            // Expanding ring
            Circle()
                .stroke(Color.dodoSuccess, lineWidth: 3)
                .frame(width: 80, height: 80)
                .scaleEffect(ringScale)
                .opacity(ringOpacity)

            // Checkmark
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(.dodoSuccess)
                .scaleEffect(checkmarkScale)
                .opacity(checkmarkOpacity)
        }
        .onAppear {
            // Checkmark appears
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                checkmarkScale = 1.0
                checkmarkOpacity = 1.0
            }

            // Ring expands and fades
            withAnimation(.easeOut(duration: 0.6)) {
                ringScale = 1.5
                ringOpacity = 0
            }

            // Auto dismiss after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onComplete()
            }
        }
    }
}

// MARK: - Pulse Effect Modifier

struct PulseEffect: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear {
                isPulsing = true
            }
    }
}

extension View {
    func pulseEffect() -> some View {
        modifier(PulseEffect())
    }
}

// MARK: - Shimmer Effect

struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.1),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + phase * geometry.size.width * 2)
                }
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmerEffect() -> some View {
        modifier(ShimmerEffect())
    }
}

#Preview {
    VStack(spacing: 40) {
        CleanerLoadingView()
        AnalyzerLoadingView()
        OptimizerLoadingView()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.dodoBackground)
}
