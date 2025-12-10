//
//  SideMenuEnvironment.swift
//  Moki
//
//  侧边栏环境值配置
//  用于控制侧边栏手势是否启用
//

import SwiftUI

// MARK: - Preference Key (子视图 → 父视图传递值)

private struct SideMenuGesturePreferenceKey: PreferenceKey {
  static var defaultValue: Bool = true

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    // 如果任何子视图禁用，则整体禁用（取 AND）
    value = value && nextValue()
  }
}

// MARK: - Environment Key (父视图 → 子视图传递值)

private struct SideMenuGestureEnabledKey: EnvironmentKey {
  static let defaultValue: Bool = true
}

extension EnvironmentValues {
  var sideMenuGestureEnabled: Bool {
    get { self[SideMenuGestureEnabledKey.self] }
    set { self[SideMenuGestureEnabledKey.self] = newValue }
  }
}

// MARK: - View Extensions

extension View {
  /// 控制侧边栏手势是否启用（在子视图中调用）
  /// - Parameter enabled: true 允许拉出侧边栏（默认），false 禁用手势
  ///
  /// 使用场景：
  /// - 二级页面：`.sideMenuGesture(enabled: false)`
  /// - Sheet/FullScreenCover：在内容视图上调用 `.sideMenuGesture(enabled: false)`
  /// - 特定视图需要禁用：在该视图上调用 `.sideMenuGesture(enabled: false)`
  func sideMenuGesture(enabled: Bool) -> some View {
    self.preference(key: SideMenuGesturePreferenceKey.self, value: enabled)
  }
}

// MARK: - Helper View for Syncing

/// 包装视图：监听子视图传递的 Preference，并同步到 Environment
struct SideMenuGestureSyncView<Content: View>: View {
  let content: Content
  @State private var gestureEnabled: Bool = true

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    content
      .onPreferenceChange(SideMenuGesturePreferenceKey.self) { newValue in
        gestureEnabled = newValue
      }
      .environment(\.sideMenuGestureEnabled, gestureEnabled)
  }
}
