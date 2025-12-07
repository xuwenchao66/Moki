//
//  ContentView.swift
//  Moki
//
//  Created by xuwecnhao on 11/23/25.
//

import SwiftUI

struct ContentView: View {
  @State private var isMenuOpen = false
  @State private var selectedTab: SideMenu.Tab = .timeline

  /// 当前菜单偏移量（-menuWidth ~ 0），默认隐藏在左侧
  @State private var menuOffset: CGFloat = -280

  private let menuWidth: CGFloat = 280

  var body: some View {
    ZStack(alignment: .leading) {
      // 1. 主内容区域 - 根据选项切换
      featureHost
        .disabled(isMenuOpen)

      // 2. 遮罩层
      if menuOffset > -menuWidth {
        Color.black
          .opacity(dimmingOpacity)
          .ignoresSafeArea()
          .onTapGesture {
            setMenu(open: false, animated: true)
          }
          .zIndex(1)
      }

      // 3. 侧边栏 - 始终存在，通过 offset 控制
      SideMenu(selectedTab: $selectedTab) {
        setMenu(open: false, animated: true)
      }
      .frame(width: menuWidth)
      .offset(x: menuOffset)
      .zIndex(2)
    }
    .gesture(
      DragGesture()
        .onChanged { value in
          let translation = value.translation.width
          let base = isMenuOpen ? 0 : -menuWidth
          let newOffset = base + translation

          // 跟手拖动，限制在 [-menuWidth, 0]
          menuOffset = Swift.max(-menuWidth, Swift.min(0, newOffset))
        }
        .onEnded { value in
          let translation = value.translation.width
          // 降低开合阈值，让轻扫也能触发。约为菜单宽度的 1/4
          let threshold = menuWidth / 4

          if isMenuOpen {
            // 已打开：向左拖超过阈值则关闭，否则回到打开
            if translation < -threshold {
              setMenu(open: false, animated: true)
            } else {
              setMenu(open: true, animated: true)
            }
          } else {
            // 已关闭：向右拖超过一半则打开，否则回到关闭
            if translation > threshold {
              setMenu(open: true, animated: true)
            } else {
              setMenu(open: false, animated: true)
            }
          }
        }
    )
    .onChange(of: selectedTab) { _, _ in
      setMenu(open: false, animated: true)
    }
  }

  // MARK: - Feature Routing

  @ViewBuilder
  private var featureHost: some View {
    switch selectedTab {
    case .timeline:
      TimelineView(
        isSideMenuPresented: Binding(
          get: { isMenuOpen },
          set: { newValue in
            setMenu(open: newValue, animated: true)
          }
        )
      )
    case .tags:
      TagsView(onMenuButtonTapped: { setMenu(open: true, animated: true) })
    case .calendar:
      FeaturePlaceholderView(
        title: placeholderTitle(.calendar),
        message: placeholderMessage(.calendar),
        systemImage: "calendar",
        onMenuButtonTapped: { setMenu(open: true, animated: true) }
      )
    case .stats:
      FeaturePlaceholderView(
        title: placeholderTitle(.stats),
        message: placeholderMessage(.stats),
        systemImage: "chart.bar",
        onMenuButtonTapped: { setMenu(open: true, animated: true) }
      )
    case .settings:
      FeaturePlaceholderView(
        title: placeholderTitle(.settings),
        message: placeholderMessage(.settings),
        systemImage: "gearshape",
        onMenuButtonTapped: { setMenu(open: true, animated: true) }
      )
    }
  }

  private func placeholderTitle(_ tab: SideMenu.Tab) -> String {
    switch tab {
    case .calendar:
      return "日历"
    case .stats:
      return "统计"
    case .settings:
      return "设置"
    case .timeline:
      return "时间轴"
    case .tags:
      return "标签"
    }
  }

  private func placeholderMessage(_ tab: SideMenu.Tab) -> String {
    switch tab {
    case .calendar:
      return "计划中的日历视图，帮助你按日期回顾灵感。"
    case .stats:
      return "统计页面尚在打磨中，将提供写作数据洞察。"
    case .settings:
      return "设置中心即将上线，敬请期待。"
    case .timeline:
      return ""
    case .tags:
      return ""
    }
  }

  // MARK: - Helpers

  private func setMenu(open: Bool, animated: Bool) {
    let action = {
      isMenuOpen = open
      menuOffset = open ? 0 : -menuWidth
    }
    if animated {
      withAnimation(.easeOut(duration: 0.2), action)
    } else {
      action()
    }
  }

  // MARK: - Computed Properties

  /// 遮罩层透明度 (0 ~ 0.4)
  private var dimmingOpacity: Double {
    // menuOffset: [-menuWidth, 0] → progress: [0, 1]
    let rawProgress = (menuOffset + menuWidth) / menuWidth
    let clamped = max(0, min(1, rawProgress))
    return Double(clamped) * 0.4
  }
}

#Preview {
  configureAppDependencies()
  return ContentView()
}

// MARK: - Placeholder

private struct FeaturePlaceholderView: View {
  let title: String
  let message: String
  let systemImage: String
  let onMenuButtonTapped: () -> Void

  var body: some View {
    NavigationStack {
      VStack(spacing: Theme.spacing.lg) {
        Spacer()

        Image(systemName: systemImage)
          .font(.system(size: 56, weight: .light))
          .foregroundColor(Theme.color.foregroundTertiary)

        VStack(spacing: Theme.spacing.sm) {
          Text("\(title)正在设计中")
            .font(Theme.font.title3)
            .foregroundColor(Theme.color.foreground)

          Text(message)
            .font(Theme.font.callout)
            .foregroundColor(Theme.color.foregroundSecondary)
            .multilineTextAlignment(.center)
        }

        Spacer()
      }
      .padding(Theme.spacing.xl)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Theme.color.background)
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            onMenuButtonTapped()
          } label: {
            Image(systemName: "line.3.horizontal")
          }
          .toolbarIconStyle()
        }
      }
    }
  }
}
