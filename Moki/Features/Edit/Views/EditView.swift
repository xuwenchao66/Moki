import SwiftUI

struct EditView: View {
  @Environment(\.dismiss) private var dismiss

  @State private var content: String = ""
  @State private var isFocused: Bool = false

  var body: some View {
    VStack(spacing: 0) {
      // 1. 输入区域
      ZStack(alignment: .topLeading) {
        PlainTextEditor(
          text: $content,
          isFocused: $isFocused,
          placeholder: "记录当下的想法..."
        )
        .frame(maxHeight: .infinity)
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

          Spacer()
        }
        .font(.system(size: 20, weight: .light))
        .foregroundColor(Theme.color.foregroundSecondary)
        .padding(.horizontal, Theme.spacing.md)
        .padding(.vertical, Theme.spacing.sm)
        .background(Theme.color.cardBackground)
      }
    }
    .background(Theme.color.background)  // 统一使用背景色
    .navigationTitle(formattedDate())
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("完成") {
          if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            dismiss()
          } else {
            saveEntry()
          }
        }
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
    formatter.dateFormat = "M月d日 EEEE HH:mm"  // 11月30日 星期日 20:30
    return formatter.string(from: Date())
  }
}

#Preview {
  EditView()
}
