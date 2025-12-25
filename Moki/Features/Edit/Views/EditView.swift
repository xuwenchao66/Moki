import SwiftUI
import UIKit

struct EditView: View {
  @Environment(\.dismiss) private var dismiss

  @State private var content: String = ""
  @State private var isFocused: Bool = false

  private let diaryService = DiaryService()

  // 保持当前时间用于显示
  private let entryDate = Date()

  var body: some View {
    VStack(spacing: 0) {
      // 1. 顶部 Header (日期 + 元数据)
      VStack(alignment: .leading, spacing: 8) {
        // 大标题日期
        Text(formattedDateMain())
          .font(Theme.font.dateTitle)
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
        .foregroundColor(Theme.color.mutedForeground)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, Theme.spacing.md)
      .padding(.top, Theme.spacing.md)
      .padding(.bottom, Theme.spacing.sm)

      // 2. 输入区域
      PlainTextEditor(
        text: $content,
        isFocused: $isFocused,
        placeholder: "在这里记录你的想法..."
      )
      .frame(maxHeight: .infinity)
      .padding(.horizontal, Theme.spacing.md)

      // 3. 底部工具栏
      VStack(spacing: 0) {
        Divider()
          .overlay(Theme.color.border)

        HStack {
          // 功能图标组
          HStack(spacing: 20) {
            Button(action: { /* TODO: Tag */  }) {
              Image(systemName: "number")
            }

            Button(action: { /* TODO: Photo */  }) {
              Image(systemName: "photo")
            }

            Button(action: { /* TODO: Camera */  }) {
              Image(systemName: "camera")
            }
          }
          .font(.system(size: 18, weight: .regular))
          .foregroundColor(Theme.color.foreground)

          Spacer()

          Button(action: {
            if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
              dismiss()
            } else {
              saveEntry()
            }
          }) {
            Image(systemName: "checkmark")
              .font(.system(size: 14, weight: .bold))
              .foregroundColor(Theme.color.buttonForeground)
              .frame(width: 56, height: 32)
              .background(Theme.color.buttonBackground)
              .clipShape(Capsule())
          }
        }
        .padding(.horizontal, Theme.spacing.md)
        .padding(.vertical, Theme.spacing.sm)
        .background(Theme.color.background)
      }
    }
    .background(Theme.color.background)
    .toolbar(.hidden, for: .navigationBar)
    .onAppear {
      isFocused = true
    }
  }

  private func saveEntry() {
    let entry = MokiDiary(
      text: content,
      createdAt: entryDate
    )
    diaryService.create(entry)
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
