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

      // 2. 底部工具栏
      VStack(spacing: 0) {
        Divider()
          .overlay(Theme.color.divider)

        HStack(spacing: 20) {
          // 功能图标
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

          Spacer()
        }
        .font(.system(size: 20, weight: .light))
        .foregroundColor(Theme.color.foregroundSecondary)
        .padding(.horizontal, Theme.spacing.md)
        .padding(.vertical, Theme.spacing.sm)
        .background(Theme.color.cardBackground)
      }
    }
    .background(Theme.color.cardBackground)
    .navigationTitle(formattedDate())
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("完成") {
          saveEntry()
        }
        .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
      }
    }
    .onAppear {
      isFocused = true
    }
  }

  private func saveEntry() {
    // TODO: 保存到数据库
    print("Saving entry: \(content)")
    dismiss()
  }

  private func formattedDate() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "M月d日 EEEE"  // 11月30日 星期日
    return formatter.string(from: Date())
  }
}

#Preview {
  EditView()
}
