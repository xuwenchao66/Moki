import SwiftUI

struct TimelineDock: View {
  var onMenuTapped: () -> Void
  var onSearchTapped: (() -> Void)?
  var onCalendarTapped: (() -> Void)?
  var onAddTapped: () -> Void

  private let dockHeight: CGFloat = 52
  private let addButtonSize: CGFloat = 52

  var body: some View {
    HStack(spacing: Theme.spacing.sm) {
      // 左侧胶囊：菜单、搜索、日历
      HStack(spacing: Theme.spacing.xs) {
        Button(action: {
          HapticManager.shared.light()
          onMenuTapped()
        }) {
          AppIcon(icon: .fadersHorizontal, size: .md, color: Theme.color.secondaryForeground)
            .withTapArea()
        }

        Button(action: {
          HapticManager.shared.light()
          onSearchTapped?()
        }) {
          AppIcon(icon: .magnifyingGlass, size: .md, color: Theme.color.secondaryForeground)
            .withTapArea()
        }

        Button(action: {
          HapticManager.shared.light()
          onCalendarTapped?()
        }) {
          AppIcon(icon: .calendarBlank, size: .md, color: Theme.color.secondaryForeground)
            .withTapArea()
        }
      }
      .padding(.horizontal, Theme.spacing.lg)
      .frame(height: dockHeight)
      .background(Theme.color.primaryForeground)
      .clipShape(Capsule())
      .shadow(color: Color(hex: "2C2523").opacity(0.08), radius: 2, x: 0, y: 1)
      .shadow(color: Color(hex: "2C2523").opacity(0.05), radius: 8, x: 0, y: 4)

      // 右侧正圆：+ 号
      Button(action: {
        HapticManager.shared.light()
        onAddTapped()
      }) {
        ZStack {
          Circle()
            .fill(Theme.color.buttonBackground)
            .frame(width: addButtonSize, height: addButtonSize)

          AppIcon(icon: .plus, size: .md, color: Theme.color.primaryForeground)
        }
      }
      .shadow(color: Color(hex: "2C2523").opacity(0.2), radius: 8, x: 0, y: 4)
    }
    .padding(.bottom, Theme.spacing.md)
  }
}

#Preview {
  ZStack(alignment: .bottom) {
    Theme.color.background
      .ignoresSafeArea()
    TimelineDock(onMenuTapped: {}, onAddTapped: {})
  }
}
