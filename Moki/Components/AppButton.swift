//
//  AppButton.swift
//  Moki
//
//  品牌按钮组件
//  提供统一的按钮样式和交互
//

import Logging
import SwiftUI

/// 按钮样式枚举
enum AppButtonStyle {
  case primary  // 主按钮 - 强调色填充
  case secondary  // 次要按钮 - 描边
  case text  // 文本按钮 - 纯文字
}

/// 品牌按钮组件
struct AppButton: View {
  let title: String
  let icon: String?
  let style: AppButtonStyle
  let action: () -> Void

  init(
    _ title: String,
    icon: String? = nil,
    style: AppButtonStyle = .primary,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.icon = icon
    self.style = style
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      HStack(spacing: Theme.spacing.xs) {
        if let icon = icon {
          Image(systemName: icon)
            .font(.system(size: 16, weight: .semibold))
        }
        Text(title)
      }
    }
    .applyButtonStyle(style)
  }
}

// MARK: - Style Application Helper

extension View {
  @ViewBuilder
  fileprivate func applyButtonStyle(_ style: AppButtonStyle) -> some View {
    switch style {
    case .primary:
      self.primaryButtonStyle()
    case .secondary:
      self.secondaryButtonStyle()
    case .text:
      self.textButtonStyle()
    }
  }
}

// MARK: - Preview

#Preview("按钮样式预览") {
  VStack(spacing: Theme.spacing.lg) {
    // 主按钮
    VStack(alignment: .leading, spacing: Theme.spacing.sm) {
      Text("主按钮 (Primary)")
        .captionStyle()

      AppButton("创建日记", icon: "plus.circle.fill", style: .primary) {
        AppLogger.preview.debug("👆 点击创建日记")
      }

      AppButton("保存", style: .primary) {
        AppLogger.preview.debug("👆 点击保存")
      }
    }

    // 次要按钮
    VStack(alignment: .leading, spacing: Theme.spacing.sm) {
      Text("次要按钮 (Secondary)")
        .captionStyle()

      AppButton("取消", icon: "xmark", style: .secondary) {
        AppLogger.preview.debug("👆 点击取消")
      }

      AppButton("查看更多", style: .secondary) {
        AppLogger.preview.debug("👆 点击查看更多")
      }
    }

    // 文本按钮
    VStack(alignment: .leading, spacing: Theme.spacing.sm) {
      Text("文本按钮 (Text)")
        .captionStyle()

      AppButton("编辑", icon: "pencil", style: .text) {
        AppLogger.preview.debug("👆 点击编辑")
      }

      AppButton("了解更多", style: .text) {
        AppLogger.preview.debug("👆 点击了解更多")
      }
    }
  }
  .padding(Theme.spacing.lg)
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Theme.color.background)
}
