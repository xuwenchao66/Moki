import SwiftUI

/// 暂无标签空状态
/// 显示在标签列表为空时
struct EmptyTagsView: View {
  var onTap: (() -> Void)?

  var body: some View {
    EmptyStateView(
      icon: .hash,
      title: "暂无标签",
      description: "标签能帮你串联起生活的线索。\n去创建第一个标签吧。",
      action: onTap
    )
  }
}

// MARK: - Preview

#Preview("无标签空状态") {
  EmptyTagsView {
    print("点击创建标签")
  }
  .background(Theme.color.background)
}
