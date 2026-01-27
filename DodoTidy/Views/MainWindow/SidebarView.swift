import SwiftUI

struct SidebarView: View {
    @Binding var selectedItem: NavigationItem?
    @State private var dodoService = DodoTidyService.shared

    var body: some View {
        VStack(spacing: 0) {
            // Logo / App header
            HStack(spacing: 10) {
                if let appIcon = NSApp.applicationIconImage {
                    Image(nsImage: appIcon)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else {
                    Image(systemName: "leaf.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.dodoPrimary)
                }

                Text("DodoTidy")
                    .font(.dodoTitle)
                    .foregroundColor(.dodoTextPrimary)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)

            // Navigation items
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(NavigationItem.allCases) { item in
                        SidebarButton(
                            item: item,
                            isSelected: selectedItem == item,
                            action: {
                                selectedItem = item
                            },
                            badgeCount: badgeCount(for: item),
                            badgeColor: badgeColor(for: item)
                        )
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 16)
            }

            Spacer()

            // Health score indicator at bottom
            healthIndicator
                .padding(16)
        }
        .frame(minWidth: 200, idealWidth: 220, maxWidth: 260)
        .background(Color.dodoBackgroundSecondary)
    }

    private var healthIndicator: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.dodoBackgroundTertiary, lineWidth: 4)
                    .frame(width: 36, height: 36)

                Circle()
                    .trim(from: 0, to: CGFloat(healthScore) / 100)
                    .stroke(healthScoreColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 36, height: 36)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: healthScore)

                Text("\(healthScore)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.dodoTextPrimary)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.3), value: healthScore)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: "sidebar.health"))
                    .font(.dodoCaption)
                    .foregroundColor(.dodoTextSecondary)

                Text(healthMessage)
                    .font(.dodoCaptionSmall)
                    .foregroundColor(.dodoTextTertiary)
                    .lineLimit(1)
                    .animation(.easeInOut(duration: 0.2), value: healthMessage)
            }

            Spacer()
        }
    }

    private var healthScore: Int {
        dodoService.status.metrics?.healthScore ?? 0
    }

    private var healthMessage: String {
        dodoService.status.metrics?.healthScoreMsg ?? "Loading..."
    }

    private var healthScoreColor: Color {
        if healthScore >= 80 { return .dodoSuccess }
        if healthScore >= 60 { return .dodoWarning }
        return .dodoDanger
    }

    // MARK: - Badge Helpers

    private func badgeCount(for item: NavigationItem) -> Int {
        switch item {
        case .dashboard:
            // Show badge if health is critical (< 50)
            return healthScore < 50 ? 1 : 0
        case .cleaner:
            // Show number of cleanable categories
            let count = dodoService.cleaner.categories.filter { !$0.items.isEmpty }.count
            return count > 0 ? count : 0
        case .optimizer:
            // Show number of pending optimization tasks
            return dodoService.optimizer.pendingTaskCount
        default:
            return 0
        }
    }

    private func badgeColor(for item: NavigationItem) -> Color {
        switch item {
        case .dashboard:
            return healthScore < 50 ? .dodoDanger : .dodoWarning
        case .cleaner:
            return .dodoInfo
        case .optimizer:
            return .dodoWarning
        default:
            return .dodoPrimary
        }
    }
}

struct SidebarButton: View {
    let item: NavigationItem
    let isSelected: Bool
    let action: () -> Void
    var badgeCount: Int = 0
    var badgeColor: Color = .dodoDanger

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.system(size: 16))
                    .frame(width: 20)
                    .scaleEffect(isSelected ? 1.1 : 1.0)

                Text(item.title)
                    .font(.dodoBody)

                Spacer()

                // Show badge if count > 0
                if badgeCount > 0 {
                    Text(badgeCount > 99 ? "99+" : "\(badgeCount)")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(badgeColor)
                        )
                        .transition(.scale.combined(with: .opacity))
                }
                // Show indicator when selected and no badge
                else if isSelected {
                    Circle()
                        .fill(Color.dodoPrimary)
                        .frame(width: 6, height: 6)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .foregroundColor(isSelected ? .dodoPrimary : (isHovering ? .dodoTextPrimary : .dodoTextSecondary))
            .background(
                RoundedRectangle(cornerRadius: DodoTidyDimensions.borderRadiusMedium)
                    .fill(isSelected ? Color.dodoPrimary.opacity(0.15) : (isHovering ? Color.dodoBackgroundTertiary : Color.clear))
            )
            .animation(.easeInOut(duration: 0.15), value: isSelected)
            .animation(.easeInOut(duration: 0.1), value: isHovering)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.1)) {
                isHovering = hovering
            }
        }
    }
}
