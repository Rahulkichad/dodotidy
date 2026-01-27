import SwiftUI

/// Toast notification type
enum ToastType {
    case success
    case warning
    case error
    case info

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return .dodoSuccess
        case .warning: return .dodoWarning
        case .error: return .dodoDanger
        case .info: return .dodoInfo
        }
    }
}

/// Toast notification data
struct ToastData: Identifiable, Equatable {
    let id = UUID()
    let type: ToastType
    let title: String
    let message: String?
    let duration: Double

    init(type: ToastType, title: String, message: String? = nil, duration: Double = 3.0) {
        self.type = type
        self.title = title
        self.message = message
        self.duration = duration
    }

    static func == (lhs: ToastData, rhs: ToastData) -> Bool {
        lhs.id == rhs.id
    }
}

/// Toast notification manager
@Observable
final class ToastManager {
    static let shared = ToastManager()

    private(set) var currentToast: ToastData?
    private var dismissTask: Task<Void, Never>?

    private init() {}

    func show(_ toast: ToastData) {
        dismissTask?.cancel()

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentToast = toast
        }

        dismissTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(toast.duration))
            if !Task.isCancelled {
                dismiss()
            }
        }
    }

    func show(type: ToastType, title: String, message: String? = nil, duration: Double = 3.0) {
        show(ToastData(type: type, title: title, message: message, duration: duration))
    }

    func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            currentToast = nil
        }
    }
}

/// Toast notification view
struct ToastView: View {
    let toast: ToastData
    let onDismiss: () -> Void

    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 12) {
            // Icon with animation
            Image(systemName: toast.type.icon)
                .font(.system(size: 20))
                .foregroundColor(toast.type.color)
                .symbolEffect(.pulse, options: .repeating.speed(0.5), value: true)

            VStack(alignment: .leading, spacing: 2) {
                Text(toast.title)
                    .font(.dodoSubheadline)
                    .foregroundColor(.dodoTextPrimary)

                if let message = toast.message {
                    Text(message)
                        .font(.dodoCaption)
                        .foregroundColor(.dodoTextSecondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            // Dismiss button
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.dodoTextTertiary)
            }
            .buttonStyle(.plain)
            .opacity(isHovering ? 1 : 0.5)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.dodoBackgroundSecondary)
                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(toast.type.color.opacity(0.3), lineWidth: 1)
        )
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

/// Toast container to be added at the root of the app
struct ToastContainer: View {
    @State private var toastManager = ToastManager.shared

    var body: some View {
        VStack {
            Spacer()

            if let toast = toastManager.currentToast {
                ToastView(toast: toast) {
                    toastManager.dismiss()
                }
                .frame(maxWidth: 400)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: toastManager.currentToast)
    }
}

#Preview {
    ZStack {
        Color.dodoBackground
            .ignoresSafeArea()

        VStack(spacing: 16) {
            ToastView(toast: ToastData(type: .success, title: "Cleaning complete", message: "Freed 2.3 GB of disk space")) {}
            ToastView(toast: ToastData(type: .warning, title: "Low disk space", message: "Only 5 GB remaining")) {}
            ToastView(toast: ToastData(type: .error, title: "Operation failed")) {}
            ToastView(toast: ToastData(type: .info, title: "Scanning in progress...")) {}
        }
        .padding()
    }
}
