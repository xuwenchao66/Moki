import SwiftUI

struct SideMenu: View {
  var onSelect: ((Tab) -> Void)?

  init(onSelect: ((Tab) -> Void)? = nil) {
    self.onSelect = onSelect
  }

  // MARK: - Tab Definition

  enum Tab: CaseIterable, Hashable, Codable {
    case search
    case stats
    case tags
    case settings

    var icon: AppIconName {
      switch self {
      case .search: return .magnifyingGlass
      case .stats: return .chartBar
      case .tags: return .hash
      case .settings: return .gearSix
      }
    }

    var title: String {
      switch self {
      case .search: return "搜索日记"
      case .stats: return "统计回顾"
      case .tags: return "标签管理"
      case .settings: return "更多设置"
      }
    }
  }

  // MARK: - Styles
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // 1. 头部：Logo + Slogan
      VStack(alignment: .leading, spacing: Theme.spacing.sm) {
        Text("Moki")
          .font(Theme.font.title1)
          .fontDesign(.serif)
          .foregroundColor(Theme.color.foreground)
          .tracking(1)

        Text("Taste life twice.")
          .font(.custom("Georgia-Italic", size: 16))
          .foregroundColor(Theme.color.mutedForeground)
          .tracking(0.5)
      }
      .padding(.top, Theme.spacing.xxxl)
      .padding(.bottom, Theme.spacing.xxl)

      // 2. 菜单列表
      VStack(alignment: .leading, spacing: Theme.spacing.xl2) {
        ForEach(Tab.allCases, id: \.self) { tab in
          MenuButton(
            icon: tab.icon,
            title: tab.title,
            action: { select(tab) }
          )
        }
      }

      Spacer()

      // 3. 底部：落款信息
      HStack(spacing: Theme.spacing.xs) {
        Text("MOKI JOURNAL")
        Text("·")
        Text("V1.0.0")
      }
      .font(Theme.font.caption)
      .foregroundColor(Theme.color.mutedForeground)
      .tracking(1)
      .padding(.bottom, Theme.spacing.xxxl)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, Theme.spacing.xl)
    .background(Theme.color.background)
    .ignoresSafeArea()
  }
}

// MARK: - Private

extension SideMenu {
  fileprivate func select(_ tab: Tab) {
    onSelect?(tab)
  }
}

// MARK: - Components

private struct MenuButton: View {
  let icon: AppIconName
  let title: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: Theme.spacing.md) {
        AppIcon(icon: icon, size: .md, color: Theme.color.mutedForeground)

        Text(title)
          .font(Theme.font.title4)
          .foregroundColor(Theme.color.foreground)
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  ZStack {
    Color.black.opacity(0.3).ignoresSafeArea()
    SideMenu()
      .frame(width: 320)
  }
}
