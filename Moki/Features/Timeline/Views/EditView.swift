import SwiftUI

struct EditView: View {
  @Environment(\.dismiss) private var dismiss

  @State private var content: String = ""
  @FocusState private var isFocused: Bool

  var body: some View {
    VStack(spacing: 0) {
      // 1. 输入区域
      ZStack(alignment: .topLeading) {
        if content.isEmpty {
          Text("记录当下的想法...")
            .font(Theme.font.body)
            .foregroundColor(Theme.color.foregroundTertiary)
            // 微调占位符位置，使其与 TextEditor 光标对齐
            .padding(.top, 8)
            .padding(.leading, 5)
        }

        TextEditor(text: $content)
          .font(Theme.font.body)
          .foregroundColor(Theme.color.foreground)
          .scrollContentBackground(.hidden)  // 移除默认背景
          .background(Color.clear)
          .focused($isFocused)
          .frame(maxHeight: .infinity)
          // TextEditor 默认有内边距，这里负向补偿以对齐边缘
          .padding(.horizontal, -4)
      }
      .padding(.horizontal, Theme.spacing.md)  // 缩小水平边距 (24 -> 16)
      .padding(.top, Theme.spacing.md)  // 缩小顶部留白 (24 -> 16)

      // 2. 底部工具栏
      VStack(spacing: 0) {
        Divider()
          .overlay(Theme.color.divider)

        HStack(spacing: 20) {  // 缩小图标间距 (24 -> 20)
          // 左侧功能区
          Group {
            Button(action: { /* TODO: Tag */  }) {
              Image(systemName: "number")
            }

            Button(action: { /* TODO: Photo */  }) {
              Image(systemName: "photo")
            }

            Button(action: { /* TODO: Format */  }) {
              Image(systemName: "bold")
            }

            Button(action: { /* TODO: List */  }) {
              Image(systemName: "list.bullet")
            }
          }
          .font(.system(size: 20, weight: .light))
          .foregroundColor(Theme.color.foregroundSecondary)

          Spacer()

          // 发送按钮
          Button(action: {
            saveEntry()
          }) {
            Image(systemName: "arrow.up")
              .font(.system(size: 18, weight: .bold))
              .foregroundColor(Theme.color.primaryActionForeground)
              .frame(width: 32, height: 32)  // 稍微调小一点，更精致
              .background(
                content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                  ? Theme.color.foregroundTertiary.opacity(0.3)
                  : Theme.color.primaryAction
              )
              .clipShape(Circle())
          }
          .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, Theme.spacing.md)
        .padding(.vertical, Theme.spacing.sm)
        .background(Theme.color.cardBackground)
      }
    }
    .background(Theme.color.cardBackground)
    .onAppear {
      isFocused = true
    }
  }

  private func saveEntry() {
    // TODO: 保存到数据库
    print("Saving entry: \(content)")
    dismiss()
  }
}

#Preview {
  EditView()
}
