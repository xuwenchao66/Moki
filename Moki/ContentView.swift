//
//  ContentView.swift
//  Moki
//
//  Created by xuwecnhao on 11/23/25.
//

import SwiftUI

struct ContentView: View {
  @State private var isMenuOpen = false
  @State private var navPath = NavigationPath()

  var body: some View {
    SideMenuGestureSyncView {
      ZStack(alignment: .leading) {
        NavigationStack(path: $navPath) {
          TimelineView(
            isSideMenuPresented: Binding(
              get: { isMenuOpen },
              set: { isMenuOpen = $0 }
            )
          )
          .navigationDestination(for: SideMenu.Tab.self) { tab in
            destinationView(for: tab)
          }
        }
        .disabled(isMenuOpen)

        SideMenuContainer(isShowing: $isMenuOpen) {
          SideMenu { tab in
            handleMenuSelection(tab)
          }
        }
      }
    }
  }

  private func handleMenuSelection(_ tab: SideMenu.Tab) {
    isMenuOpen = false
    navPath = NavigationPath()
    navPath.append(tab)
  }

  @ViewBuilder
  private func destinationView(for tab: SideMenu.Tab) -> some View {
    switch tab {
    case .tags:
      TagsView(onMenuButtonTapped: { isMenuOpen = true })
    case .calendar:
      FeaturePlaceholderView(
        title: placeholderTitle(.calendar),
        message: placeholderMessage(.calendar),
        systemImage: "calendar",
        onMenuButtonTapped: { isMenuOpen = true }
      )
    case .stats:
      FeaturePlaceholderView(
        title: placeholderTitle(.stats),
        message: placeholderMessage(.stats),
        systemImage: "chart.bar",
        onMenuButtonTapped: { isMenuOpen = true }
      )
    case .settings:
      FeaturePlaceholderView(
        title: placeholderTitle(.settings),
        message: placeholderMessage(.settings),
        systemImage: "gearshape",
        onMenuButtonTapped: { isMenuOpen = true }
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
    case .tags:
      return ""
    }
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
    VStack(spacing: Theme.spacing.lg) {
      Spacer()

      Image(systemName: systemImage)
        .font(.system(size: 56, weight: .light))
        .foregroundColor(Theme.color.mutedForeground)

      VStack(spacing: Theme.spacing.sm) {
        Text("\(title)正在设计中")
          .font(Theme.font.title3)
          .foregroundColor(Theme.color.foreground)

        Text(message)
          .font(Theme.font.callout)
          .foregroundColor(Theme.color.mutedForeground)
          .multilineTextAlignment(.center)
      }

      Spacer()
    }
    .padding(Theme.spacing.xl)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.color.background)
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)

  }
}
