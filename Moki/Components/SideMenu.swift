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
          // Header: Logo
          VStack(alignment: .leading) {
            Text("Moki")
              .font(Theme.font.largeTitle)  // Serif 34pt Bold
              .foregroundColor(Theme.color.foreground)
          }
          .padding(.top, 60)  // 增加顶部留白，适应刘海屏
          .padding(.horizontal, Theme.spacing.xl)  // 增加水平间距 24 -> 32
          .padding(.bottom, Theme.spacing.xxl)

          // Menu Items
          VStack(spacing: Theme.spacing.md) {  // 增加菜单项垂直间距 12 -> 16
            MenuButton(
              icon: "dock.rectangle",  // 类似时间轴的图标
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
              icon: "number",  // 标签图标
              title: "标签",
              isSelected: selectedTab == .tags,
              action: { selectedTab = .tags }
            )

            MenuButton(
              icon: "chart.bar",  // 统计图标
              title: "统计",
              isSelected: selectedTab == .stats,
              action: { selectedTab = .stats }
            )
          }
          .padding(.horizontal, Theme.spacing.lg)  // 增加菜单水平间距 16 -> 24

          Spacer()

          // Footer
          VStack(spacing: Theme.spacing.lg) {
            // 设置按钮 (作为菜单项样式但未选中)
            MenuButton(
              icon: "gearshape",
              title: "设置",
              isSelected: selectedTab == .settings,
              action: { selectedTab = .settings }
            )

            // 版本号
            Text("V1.0.0")
              .font(Theme.font.caption)
              .foregroundColor(Theme.color.foregroundTertiary)
              .frame(maxWidth: .infinity, alignment: .center)
              .padding(.bottom, Theme.spacing.lg)
          }
          .padding(.horizontal, Theme.spacing.lg)
          .padding(.bottom, Theme.spacing.md)  // 底部安全区预留
        }
        .frame(width: 280)  // 固定侧边栏宽度
        .background(Theme.color.background)  // 使用主背景色，与 README 一致 (Beige/Warm White)
        .edgesIgnoringSafeArea(.all)

        // 2. 透明占位区域 (点击此处也可关闭，由父视图控制)
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
          .font(.system(size: 20, weight: isSelected ? .medium : .regular))  // 增加图标字重和尺寸
          .frame(width: 24)

        Text(title)
          .font(Theme.font.body)  // 保持 17pt
          .fontWeight(isSelected ? .medium : .regular)  // 选中态加粗，未选中态常规，符合截图
      }
      .foregroundColor(isSelected ? Theme.color.cardBackground : Theme.color.foregroundSecondary)  // 选中反白，未选中深灰
      .padding(.vertical, 14)  // 增加垂直内边距 12 -> 14
      .padding(.horizontal, Theme.spacing.md)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(
        RoundedRectangle(cornerRadius: Theme.radius.md)
          .fill(isSelected ? Theme.color.primaryAction : Color.clear)  // 选中态黑色背景
      )
    }
    .buttonStyle(.plain)  // 移除默认点击效果，使用自定义样式
    .contentShape(Rectangle())  // 扩大点击区域
  }
}

#Preview {
  ZStack {
    Color.black.opacity(0.3).ignoresSafeArea()
    SideMenu()
  }
}
