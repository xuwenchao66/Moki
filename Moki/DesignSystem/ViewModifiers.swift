//
//  ViewModifiers.swift
//  Moki
//
//  通用视图修饰符
//  提供一致的 UI 样式，如 .cardStyle()、.buttonStyle() 等
//

import SwiftUI

// MARK: - Separator (分割线)

struct Separator: View {
  var color: Color = Theme.color.border
  var height: CGFloat = 1

  var body: some View {
    Rectangle()
      .fill(color)
      .frame(height: height)
  }
}

// MARK: - Spacer Helpers

extension View {
  /// 添加垂直间距
  func vSpacing(_ spacing: CGFloat) -> some View {
    self.padding(.vertical, spacing)
  }

  /// 添加水平间距
  func hSpacing(_ spacing: CGFloat) -> some View {
    self.padding(.horizontal, spacing)
  }
}

// MARK: - Conditional Modifiers

extension View {
  /// 条件修饰符
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
