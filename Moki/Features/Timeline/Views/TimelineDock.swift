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
          AppIcon(icon: .fadersHorizontal, size: .md, color: Theme.color.mutedForeground)
            .withTapArea()
        }

        Button(action: {
          HapticManager.shared.light()
          onSearchTapped?()
        }) {
          AppIcon(icon: .magnifyingGlass, size: .md, color: Theme.color.mutedForeground)
            .withTapArea()
        }

        Button(action: {
          HapticManager.shared.light()
          onCalendarTapped?()
        }) {
          AppIcon(icon: .calendarBlank, size: .md, color: Theme.color.mutedForeground)
            .withTapArea()
        }
      }
      .padding(.horizontal, Theme.spacing.lg)
      .frame(height: dockHeight)
      .background(Theme.color.primaryForeground)
      .clipShape(Capsule())
      .cardShadow()

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
      .appShadow(Theme.shadow.md)
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
