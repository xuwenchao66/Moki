import SwiftUI

struct TimelineDock: View {
  var onMenuTapped: () -> Void
  var onAddTapped: () -> Void

  var body: some View {
    HStack(spacing: 24) {
      Button(action: {
        withAnimation {
          onMenuTapped()
        }
      }) {
        AppIcon(icon: .fadersHorizontal, size: .md, color: Theme.color.cardForeground)
          .withTapArea()
      }

      Button(action: { onAddTapped() }) {
        ZStack {
          Circle()
            .fill(Theme.color.buttonBackground)
            .frame(width: 44, height: 44)
            .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 4)

          AppIcon(icon: .plus, size: .sm, color: Theme.color.primaryForeground)
        }
      }

      Button(action: {
        // Placeholder for calendar action
      }) {
        AppIcon(icon: .calendarBlank, size: .md, color: Theme.color.cardForeground)
          .withTapArea()
      }
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 6)
    .background(.ultraThinMaterial)
    .background(Theme.color.primaryForeground.opacity(0.85))
    .clipShape(Capsule())
    .shadow(color: Color(hex: "2C2825").opacity(0.12), radius: 32, x: 0, y: 12)
    .shadow(color: Color(hex: "2C2825").opacity(0.06), radius: 12, x: 0, y: 4)
    .overlay(
      Capsule()
        .stroke(Theme.color.primaryForeground.opacity(0.6), lineWidth: 1)
    )
    .padding(.bottom, 34)
  }
}

#Preview {
  ZStack(alignment: .bottom) {
    Color.gray.opacity(0.1).ignoresSafeArea()
    TimelineDock(onMenuTapped: {}, onAddTapped: {})
  }
}
