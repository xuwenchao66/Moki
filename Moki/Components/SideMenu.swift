//
//  SideMenu.swift
//  Moki
//
//  侧边栏导航菜单
//  遵循 Claude 温暖风格：简约、温暖、橙色主题
//

import SwiftUI

struct SideMenu: View {
  @Binding var selectedTab: Tab
  var onSelect: (() -> Void)?

  init(selectedTab: Binding<Tab>, onSelect: (() -> Void)? = nil) {
    _selectedTab = selectedTab
    self.onSelect = onSelect
  }

  // MARK: - Tab Definition

  enum Tab: CaseIterable {
    case timeline
    case calendar
    case tags
    case stats
    case settings

    var icon: String {
      switch self {
      case .timeline: return "dock.rectangle"
      case .calendar: return "calendar"
      case .tags: return "number"
      case .stats: return "chart.bar"
      case .settings: return "gearshape"
      }
    }

    var title: String {
      switch self {
      case .timeline: return "时间轴"
      case .calendar: return "日历"
      case .tags: return "标签"
      case .stats: return "统计"
      case .settings: return "设置"
      }
    }

    /// 是否在底部显示（设置项）
    var isBottomItem: Bool {
      self == .settings
    }
  }

  var body: some View {
    GeometryReader { proxy in
      HStack(spacing: 0) {
        // 1. 侧边栏主体
        VStack(alignment: .leading, spacing: 0) {
          // 留白 Header
          Spacer()
            .frame(height: 100)

          // 主菜单项
          VStack(spacing: 20) {
            ForEach(Tab.allCases.filter { !$0.isBottomItem }, id: \.self) { tab in
              MenuButton(
                icon: tab.icon,
                title: tab.title,
                isSelected: selectedTab == tab,
                action: { select(tab) }
              )
            }
          }
          .padding(.horizontal, Theme.spacing.xl)

          Spacer()

          // 底部菜单项（设置）
          ForEach(Tab.allCases.filter { $0.isBottomItem }, id: \.self) { tab in
            MenuButton(
              icon: tab.icon,
              title: tab.title,
              isSelected: selectedTab == tab,
              action: { select(tab) }
            )
          }
          .padding(.horizontal, Theme.spacing.xl)
          .padding(.bottom, Theme.spacing.xxl)
        }
        .frame(width: 280)
        .background(Theme.color.secondary)
        .edgesIgnoringSafeArea(.all)

        // 2. 透明占位区域
        Spacer()
      }
    }
  }
}

// MARK: - Private

extension SideMenu {
  fileprivate func select(_ tab: Tab) {
    guard selectedTab != tab else {
      onSelect?()
      return
    }
    selectedTab = tab
    onSelect?()
  }
}

// MARK: - Components

private struct MenuButton: View {
  let icon: String
  let title: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: Theme.spacing.md) {
        Image(systemName: icon)
          .font(.system(size: 17, weight: isSelected ? .medium : .light))  // 图标微调小一点，Weight 变轻
          .frame(width: 22)  // 限制图标宽度

        Text(title)
          .font(.system(size: 16))  // 字体稍微改小一点点，更精致
          .fontWeight(isSelected ? .medium : .regular)
      }
      .foregroundColor(isSelected ? Theme.color.primary : Theme.color.mutedForeground)
      .padding(.vertical, 4)  // 大幅减小垂直 Padding，依靠 Stack spacing 控制间距
      .frame(maxWidth: .infinity, alignment: .leading)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  ZStack {
    Color.black.opacity(0.3).ignoresSafeArea()
    SideMenu(selectedTab: .constant(.timeline))
  }
}
