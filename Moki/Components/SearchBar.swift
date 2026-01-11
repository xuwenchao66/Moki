import SwiftUI

/// 搜索框组件 - 简洁下划线风格
/// 无边框包裹，底部细线分隔，保持空气感
struct SearchBar: View {
  @Binding var text: String
  var placeholder: String = "搜索..."

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: Theme.spacing.sm) {
        Image(systemName: "magnifyingglass")
          .font(.system(size: 18, weight: .regular))
          .foregroundColor(Theme.color.mutedForeground)

        TextField(placeholder, text: $text)
          .font(Theme.font.body)
          .foregroundColor(Theme.color.foreground)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()

        if !text.isEmpty {
          Button {
            text = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
              .font(.system(size: 16))
              .foregroundColor(Theme.color.mutedForeground)
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.vertical, Theme.spacing.md)

      // 底部分隔线
      Rectangle()
        .fill(Theme.color.border)
        .frame(height: 1)
    }
  }
}

// MARK: - Preview

#Preview {
  VStack(spacing: Theme.spacing.xl) {
    SearchBar(text: .constant(""), placeholder: "搜索或创建标签...")

    SearchBar(text: .constant("Design"), placeholder: "搜索或创建标签...")
  }
  .padding(.horizontal, Theme.spacing.md2)
  .background(Theme.color.background)
}
