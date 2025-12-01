//
//  SideMenu.swift
//  Moki
//
//  侧边栏导航菜单
//  遵循 README.md 风格：简约、温暖、Beige 色调
//

import SwiftUI

struct SideMenu: View {
  // 当前选中的菜单项，默认为 .timeline
  @State private var selectedTab: Tab = .timeline

  enum Tab {
    case timeline
    case calendar
    case tags
    case stats
    case settings
  }

  var body: some View {
    GeometryReader { proxy in
      HStack(spacing: 0) {
        // 1. 侧边栏主体
        VStack(alignment: .leading, spacing: 0) {
          // 留白 Header
          Spacer()
            .frame(height: 100)

          // Menu Items
          VStack(spacing: 20) {  // 将 spacing 调整为 20，配合较小的 padding，更紧凑精致
            MenuButton(
              icon: "dock.rectangle",
              title: "时间轴",
              isSelected: selectedTab == .timeline,
              action: { selectedTab = .timeline }
            )

            MenuButton(
              icon: "calendar",
              title: "日历",
              isSelected: selectedTab == .calendar,
              action: { selectedTab = .calendar }
            )

            MenuButton(
              icon: "number",
              title: "标签",
              isSelected: selectedTab == .tags,
              action: { selectedTab = .tags }
            )

            MenuButton(
              icon: "chart.bar",
              title: "统计",
              isSelected: selectedTab == .stats,
              action: { selectedTab = .stats }
            )
          }
          .padding(.horizontal, Theme.spacing.xl)  // 水平间距 32

          Spacer()

          // Settings Bottom
          MenuButton(
            icon: "gearshape",
            title: "设置",
            isSelected: selectedTab == .settings,
            action: { selectedTab = .settings }
          )
          .padding(.horizontal, Theme.spacing.xl)
          .padding(.bottom, Theme.spacing.xxl)  // 底部留出较多空白，显得沉稳
        }
        .frame(width: 280)
        .background(Theme.color.background)
        .edgesIgnoringSafeArea(.all)

        // 2. 透明占位区域
        Spacer()
      }
    }
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
      .foregroundColor(isSelected ? Theme.color.foreground : Theme.color.foregroundSecondary)
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
    SideMenu()
  }
}
