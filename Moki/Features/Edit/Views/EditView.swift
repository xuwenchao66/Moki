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
          placeholder: "在这里记录你的想法..."
        )
        .frame(maxHeight: .infinity)
      }
      .padding(.horizontal, Theme.spacing.md)

      // 3. 底部工具栏
      VStack(spacing: 0) {
        Divider()
          .overlay(Theme.color.divider)

        HStack {
          // 功能图标组
          HStack(spacing: 24) {
            Button(action: { /* TODO: Tag */  }) {
              Image(systemName: "number")
            }

            Button(action: { /* TODO: Photo */  }) {
              Image(systemName: "photo")
            }

            Button(action: { /* TODO: Location */  }) {
              Image(systemName: "mappin.and.ellipse")
            }

            Button(action: { /* TODO: Mood */  }) {
              Image(systemName: "face.smiling")
            }
          }
          .font(.system(size: 20, weight: .light))
          .foregroundColor(Theme.color.foregroundSecondary)

          Spacer()

          // 完成按钮
          Button(action: {
            if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
              dismiss()
            } else {
              saveEntry()
            }
          }) {
            Image(systemName: "checkmark")
              .font(.system(size: 16, weight: .bold))
              .foregroundColor(Theme.color.background)  // 图标颜色与页面背景一致 (反色)
              .frame(width: 64, height: 36)
              .background(Theme.color.foreground)  // 按钮背景使用主前景色 (黑/白)
              .clipShape(Capsule())
          }
        }
        .padding(.horizontal, Theme.spacing.md)
        .padding(.vertical, Theme.spacing.sm)
        .background(Theme.color.cardBackground.opacity(0.95))
      }
    }
    .background(Theme.color.background)
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("")  // 隐藏导航栏标题
    .toolbar(.hidden, for: .navigationBar)  // 彻底隐藏导航栏 (可选，或者保留空标题)
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
