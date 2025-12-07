import SwiftUI
import UIKit

struct EditView: View {
  @Environment(\.dismiss) private var dismiss

  @State private var content: String = ""
  @State private var isFocused: Bool = false

  // 保持当前时间用于显示
  private let entryDate = Date()

  var body: some View {
    VStack(spacing: 0) {
      // 1. 顶部 Header (日期 + 元数据)
      VStack(alignment: .leading, spacing: 8) {
        // 大标题日期
        Text(formattedDateMain())
          .font(.system(size: 28, weight: .semibold, design: .serif))
          .foregroundColor(Theme.color.foreground)

        // 元数据：星期 · 时间 · 天气/心情
        HStack(spacing: 6) {
          Text(formattedDateSub())
          Text("·")
          Text(formattedTime())
          Text("·")
          Label("多云", systemImage: "cloud.sun.fill")  // TODO: 自动获取天气
            .font(.system(size: 13))
        }
        .font(.system(size: 14))
        .foregroundColor(Theme.color.foregroundSecondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, Theme.spacing.md)
      .padding(.top, Theme.spacing.md)
      .padding(.bottom, Theme.spacing.sm)

      // 2. 输入区域
      ZStack(alignment: .topLeading) {
        PlainTextEditor(
          text: $content,
          isFocused: $isFocused,
          placeholder: "在这里记录你的想法...",
        )
        .frame(maxHeight: .infinity)
      }
      .padding(.horizontal, Theme.spacing.md)

      // 3. 底部工具栏
      VStack(spacing: 0) {
        Divider()
          .overlay(Theme.color.divider)

        HStack {
          // Tag
          Button(action: { /* TODO: Tag */  }) {
            Image(systemName: "number")
          }

          Spacer()

          // Photo
          Button(action: { /* TODO: Photo */  }) {
            Image(systemName: "photo")
          }

          Spacer()

          // Location
          Button(action: { /* TODO: Location */  }) {
            Image(systemName: "mappin.and.ellipse")
          }

          Spacer()

          // Mood
          Button(action: { /* TODO: Mood */  }) {
            Image(systemName: "face.smiling")
          }

          Spacer()

          // 收起键盘
          Button(action: {
            UIApplication.shared.sendAction(
              #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
          }) {
            Image(systemName: "keyboard.chevron.compact.down")
          }
        }
        .font(.system(size: 20, weight: .light))
        .foregroundColor(Theme.color.foregroundSecondary)
        .padding(.horizontal, 32)
        .padding(.vertical, Theme.spacing.md)
        .background(Theme.color.cardBackground.opacity(0.95))
      }
    }
    .background(Theme.color.background)
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("")  // 隐藏导航栏标题
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("完成") {
          if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            dismiss()
          } else {
            saveEntry()
          }
        }
        .font(.headline)  // 加粗
        .foregroundColor(Theme.color.foreground)  // 使用主色调 (黑色)
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

  // MARK: - Date Formatters

  private func formattedDateMain() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "yyyy年M月d日"
    return formatter.string(from: entryDate)
  }

  private func formattedDateSub() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "EEEE"
    return formatter.string(from: entryDate)
  }

  private func formattedTime() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: entryDate)
  }
}

#Preview {
  NavigationView {
    EditView()
  }
}
