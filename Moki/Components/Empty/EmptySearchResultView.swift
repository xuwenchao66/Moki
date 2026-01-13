import SwiftUI

/// 搜索无结果空状态
/// 显示在搜索没有匹配结果时
struct EmptySearchResultView: View {
  var onTap: (() -> Void)?

  var body: some View {
    EmptyStateView(
      icon: .magnifyingGlass,
      title: "未找到相关日记",
      description: "换个关键词试试？\n或许它藏在另一个时刻里。",
      action: onTap
    )
  }
}

// MARK: - Preview

#Preview("搜索无结果空状态") {
  EmptySearchResultView()
    .background(Theme.color.background)
}
