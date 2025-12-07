import SwiftUI

/// 左侧日期组件
struct JournalDateView: View {
  let date: Date

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Text(dayString)
        .font(Theme.font.title3.weight(.bold))  // 加粗，更大一点
        .foregroundColor(Theme.color.foreground)

      Text(weekdayString)
        .font(Theme.font.caption)
        .foregroundColor(Theme.color.foregroundSecondary)  // 浅灰色
    }
    .frame(width: 40)  // 稍微加宽一点以适应加粗字体
  }

  private var dayString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    return formatter.string(from: date)
  }

  private var weekdayString: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "EEE"
    return formatter.string(from: date)
  }
}

/// 右侧卡片组件
struct JournalCardView: View {
  let content: String
  let date: Date
  let tags: [String]
  var images: [String] = []

  // Callbacks
  var onEditTapped: (() -> Void)? = nil
  var onDeleteTapped: (() -> Void)? = nil

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.spacing.sm) {
      HStack(alignment: .top) {
        Text(content)
          .font(Theme.font.journalBody)
          .foregroundColor(Theme.color.foreground)
          .lineSpacing(Theme.spacing.textLineSpacing)
          .fixedSize(horizontal: false, vertical: true)

        Spacer()
      }

      // 图片区域
      if !images.isEmpty {
        HStack(spacing: Theme.spacing.sm) {
          ForEach(0..<images.count, id: \.self) { _ in
            RoundedRectangle(cornerRadius: Theme.radius.sm)
              .fill(Theme.color.border)
              .overlay(
                Image(systemName: "photo")
                  .foregroundColor(Theme.color.foregroundSecondary)
              )
              .frame(height: 100)
              .frame(maxWidth: .infinity)
              .clipped()
          }
        }
        .padding(.vertical, 4)
      }

      // 底部元数据: 时间 + 标签
      HStack(alignment: .center, spacing: Theme.spacing.sm) {
        // 时间
        Text(timeString)
          .font(Theme.font.caption)
          .foregroundColor(Theme.color.foregroundTertiary)

        // 标签
        if !tags.isEmpty {
          ForEach(tags, id: \.self) { tag in
            Text("#\(tag)")
              .font(Theme.font.caption)
              .foregroundColor(Theme.color.foregroundSecondary)
          }
        }

        Spacer()

        Menu {
          menuItems
        } label: {
          Image(systemName: "ellipsis")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Theme.color.foregroundTertiary)
            .frame(width: 24, height: 24)
            .contentShape(Rectangle())
        }
      }
      .padding(.top, 4)
    }
    .padding(Theme.spacing.md)
    .background(Theme.color.cardBackground)
    .cornerRadius(Theme.radius.md)
    .shadow(
      color: Theme.shadow.sm.color, radius: Theme.shadow.sm.radius, x: Theme.shadow.sm.x,
      y: Theme.shadow.sm.y
    )
    .contextMenu {
      menuItems
    }
  }

  @ViewBuilder
  private var menuItems: some View {
    if let onEditTapped {
      Button(action: onEditTapped) {
        Label("编辑", systemImage: "pencil")
      }
    }

    if let onDeleteTapped {
      Button(role: .destructive, action: onDeleteTapped) {
        Label("删除", systemImage: "trash")
      }
    }
  }

  private var timeString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
}
