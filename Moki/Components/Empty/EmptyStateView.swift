import Logging
import SwiftUI

/// 空状态视图
/// 提供统一的空状态展示样式，包含图标、标题和描述
struct EmptyStateView: View {
  let icon: AppIconName?
  let title: String
  let description: String
  var action: (() -> Void)?

  /// 空状态图标尺寸
  private let iconSize: CGFloat = 64

  init(
    icon: AppIconName? = nil,
    title: String,
    description: String,
    action: (() -> Void)? = nil
  ) {
    self.icon = icon
    self.title = title
    self.description = description
    self.action = action
  }

  var body: some View {
    Button {
      action?()
    } label: {
      VStack(spacing: 0) {
        Spacer()

        // 图标
        if let icon = icon {
          AppIcon(icon: icon, size: iconSize, color: Theme.color.secondary)
            .padding(.bottom, Theme.spacing.lg)
        }

        // 标题和描述
        VStack(spacing: Theme.spacing.sm) {
          Text(title)
            .font(Theme.font.title3)
            .foregroundColor(Theme.color.foreground)

          Text(description)
            .font(Theme.font.footnote)
            .foregroundColor(Theme.color.mutedForeground)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
        }

        Spacer()
      }
      .padding(.horizontal, 40)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

// MARK: - Preview

#Preview("空状态预览") {
  ScrollView {
    VStack(spacing: 0) {
      // 无日记记录
      EmptyStateView(
        icon: .bookOpenText,
        title: "空白的纸张",
        description: "生活值得再品味一次。\n点击底部的 + 号，写下第一篇。"
      ) {
        AppLogger.preview.debug("👆 点击创建日记")
      }
      .frame(height: 400)
      .background(Theme.color.background)

      Separator()

      // 无搜索结果
      EmptyStateView(
        icon: .magnifyingGlass,
        title: "未找到相关日记",
        description: "换个关键词试试？\n或许它藏在另一个时刻里。"
      )
      .frame(height: 400)
      .background(Theme.color.background)

      Separator()

      // 无标签
      EmptyStateView(
        icon: .hash,
        title: "暂无标签",
        description: "标签能帮你串联起生活的线索。\n去创建第一个标签吧。"
      )
      .frame(height: 400)
      .background(Theme.color.background)
    }
  }
  .background(Theme.color.background)
}
