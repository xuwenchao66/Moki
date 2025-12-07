//
//  EmptyStateView.swift
//  Moki
//
//  空状态占位图
//  提供友好的空状态提示
//

import Logging
import SwiftUI

/// 空状态视图
struct EmptyStateView: View {
  let title: String
  let message: String
  var action: (() -> Void)?

  init(
    title: String,
    message: String,
    action: (() -> Void)? = nil
  ) {
    self.title = title
    self.message = message
    self.action = action
  }

  var body: some View {
    Button {
      action?()
    } label: {
      VStack(spacing: Theme.spacing.lg) {
        Spacer()

        // 标题和描述
        VStack(spacing: Theme.spacing.xs) {
          Text(title)
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
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

// MARK: - Preview

#Preview("空状态预览") {
  VStack(spacing: 0) {
    // 无日记记录
    EmptyStateView(
      title: "还没有日记",
      message: "开始记录你的第一条想法吧\n每一个当下都值得被记住",
    ) {
      AppLogger.preview.debug("👆 点击创建日记")
    }
    .frame(height: 400)
    .background(Theme.color.background)

    Separator()

    // 无搜索结果
    EmptyStateView(
      title: "没有找到相关内容",
      message: "试试其他关键词"
    )
    .frame(height: 400)
    .background(Theme.color.background)
  }
}
