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

// MARK: - Journal Text Style (日记正文样式)

/// 日记正文样式修饰符
/// 衬线体 + 舒适行高 + 正文色
/// 用于日记内容、长文本阅读场景
struct JournalBodyStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(Theme.font.journalBody)
      .kerning(Theme.font.journalBodyKerning)
      .foregroundColor(Theme.color.foreground)
      .multilineTextAlignment(.leading)
      .lineSpacing(Theme.font.journalBodyLineSpacing)
  }
}

extension View {
  /// 应用日记正文样式
  /// 衬线体 17pt + 行高 1.85 + 前景色
  func journalBodyStyle() -> some View {
    modifier(JournalBodyStyle())
  }
}
