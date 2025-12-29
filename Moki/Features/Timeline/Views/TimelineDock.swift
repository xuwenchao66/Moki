import SwiftUI

struct TimelineDock: View {
  var onMenuTapped: () -> Void
  var onAddTapped: () -> Void
  var onCalendarTapped: (() -> Void)?

  var body: some View {
    HStack(spacing: Theme.spacing.lg2) {
      Button(action: {
        HapticManager.shared.light()
        onMenuTapped()
      }) {
        AppIcon(icon: .fadersHorizontal, size: .md, color: Theme.color.cardForeground)
          .withTapArea()
      }

      Button(action: {
        HapticManager.shared.light()
        onAddTapped()
      }) {
        ZStack {
          Circle()
            .fill(Theme.color.buttonBackground)
            .frame(width: 42, height: 42)
            .shadow(color: Color.black.opacity(0.14), radius: 18, x: 0, y: 8)

          AppIcon(icon: .plus, size: .sm, color: Theme.color.primaryForeground)
        }
      }

      Button(action: {
        HapticManager.shared.light()
        onCalendarTapped?()
      }) {
        AppIcon(icon: .calendarBlank, size: .md, color: Theme.color.cardForeground)
          .withTapArea()
      }
    }
    .padding(.horizontal, Theme.spacing.md)
    .padding(.vertical, Theme.spacing.compact)
    .background(Theme.color.primaryForeground)
    .clipShape(Capsule())
    .overlay(
      Capsule()
        .stroke(Theme.color.primaryForeground.opacity(0.6), lineWidth: 1)
    )
    .shadow(color: Color(hex: "2C2825").opacity(0.08), radius: 2, x: 0, y: 2)
    .shadow(color: Color(hex: "2C2825").opacity(0.06), radius: 16, x: 0, y: 8)
    .padding(.bottom, 32)
  }
}

#Preview {
  ZStack(alignment: .bottom) {
    Theme.color.background
      .ignoresSafeArea()
    TimelineDock(onMenuTapped: {}, onAddTapped: {})
  }
}
