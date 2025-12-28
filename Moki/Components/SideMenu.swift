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
      case .search: return "搜索"
      case .stats: return "统计"
      case .tags: return "标签"
      case .settings: return "设置"
      }
    }

    // 标记哪些 Tab 属于主要功能区（顶部）
    var isMainFeature: Bool {
      switch self {
      case .search, .stats, .tags: return true
      case .settings: return false
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
      .padding(.top, Theme.spacing.xxxl + Theme.spacing.sm)
      .padding(.bottom, Theme.spacing.xxl)

      // 2. 菜单列表 (主要功能区)
      VStack(alignment: .leading, spacing: Theme.spacing.xl2) {
        ForEach(Tab.allCases.filter { $0.isMainFeature }, id: \.self) { tab in
          MenuButton(
            icon: tab.icon,
            title: tab.title,
            action: { select(tab) }
          )
        }
      }

      // X App Style: 自动撑开中间区域
      Spacer()

      // 3. 底部区域 (分割线 + 设置 + 版本号)
      VStack(alignment: .leading, spacing: 0) {
        // 分割线
        Rectangle()
          .fill(Theme.color.border.opacity(0.3))
          .frame(height: 1)
          .padding(.bottom, Theme.spacing.xl)

        // 设置入口 (沉底)
        ForEach(Tab.allCases.filter { !$0.isMainFeature }, id: \.self) { tab in
          MenuButton(
            icon: tab.icon,
            title: tab.title,
            action: { select(tab) }
          )
        }

        // 落款信息
        HStack(spacing: Theme.spacing.xs) {
          Text("MOKI JOURNAL")
          Text("·")
          Text("V1.0.0")
        }
        .font(Theme.font.caption)
        .foregroundColor(Theme.color.mutedForeground)
        .tracking(1)
        .padding(.top, Theme.spacing.xl)
        .padding(.bottom, Theme.spacing.xxxl)
      }
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
    HStack(spacing: Theme.spacing.md2) {
      AppIcon(icon: icon, size: .sm, color: Theme.color.secondaryForeground)

      Text(title)
        .font(Theme.font.body)
        .foregroundColor(Theme.color.secondaryForeground)

      Spacer()
    }
    .contentShape(Rectangle())
    .onTapGesture {
      HapticManager.shared.light()
      action()
    }
  }
}

#Preview {
  ZStack {
    Color.black.opacity(0.3).ignoresSafeArea()
    SideMenu()
      .frame(width: 320)
  }
}
