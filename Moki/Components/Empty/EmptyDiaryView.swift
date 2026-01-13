//
//  EmptyDiaryView.swift
//  Moki
//
//  首页无日记时的空状态视图
//

import SwiftUI

/// 首页无日记空状态
/// 显示在时间线没有任何日记记录时
struct EmptyDiaryView: View {
  var onTap: (() -> Void)?

  var body: some View {
    EmptyStateView(
      icon: .bookOpenText,
      title: "空白的纸张",
      description: "生活值得再品味一次。\n点击底部的 + 号，写下第一篇。",
      action: onTap
    )
  }
}

// MARK: - Preview

#Preview("无日记空状态") {
  EmptyDiaryView {
    print("点击创建日记")
  }
  .background(Theme.color.background)
}
