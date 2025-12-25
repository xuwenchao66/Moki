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
  /// 使用 Optional 表示「未声明偏好」的状态，便于实现默认禁用且可被子视图启用/禁用
  static var defaultValue: Bool? = nil

  static func reduce(value: inout Bool?, nextValue: () -> Bool?) {
    let next = nextValue()

    // 若任何子视图明确禁用，则最终禁用；否则只要有一个视图启用且前面没有禁用则启用
    switch (value, next) {
    case (_, .some(false)):
      value = false
    case (nil, .some(true)):
      value = true
    default:
      break
    }
  }
}

// MARK: - Environment Key (父视图 → 子视图传递值)

private struct SideMenuGestureEnabledKey: EnvironmentKey {
  static let defaultValue: Bool = false  // 默认禁用，按需启用
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
  @State private var gestureEnabled: Bool = false

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    content
      .onPreferenceChange(SideMenuGesturePreferenceKey.self) { newValue in
        // 未声明时默认禁用；若有启用声明且无禁用声明，则启用
        gestureEnabled = newValue ?? false
      }
      .environment(\.sideMenuGestureEnabled, gestureEnabled)
  }
}
