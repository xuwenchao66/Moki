import SwiftUI

/// 左侧日期组件
struct JournalDateView: View {
  let date: Date

  var body: some View {
    VStack(alignment: .center, spacing: Theme.spacing.xxs) {
      Text(dayString)
        .font(Theme.font.title3.weight(.semibold))
        .foregroundColor(Theme.color.foreground)

      Text(weekdayString)
        .font(Theme.font.micro)
        .foregroundColor(Theme.color.foregroundSecondary)
        .textCase(.uppercase)
    }
    .frame(width: 44)
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

/// 右侧内容组件 (恢复卡片感，增强分隔)
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
      // 1. 内容区域
      Text(content)
        .font(Theme.font.journalBody)
        .foregroundColor(Theme.color.foreground)
        .lineSpacing(Theme.spacing.compact)
        .fixedSize(horizontal: false, vertical: true)

      // 2. 图片区域
      if !images.isEmpty {
        LazyVGrid(
          columns: [GridItem(.adaptive(minimum: 80), spacing: Theme.spacing.xs)],
          spacing: Theme.spacing.xs
        ) {
          ForEach(0..<images.count, id: \.self) { _ in
            RoundedRectangle(cornerRadius: Theme.radius.sm)
              .fill(Theme.color.background)  // 图片占位背景改为大背景色，形成对比
              .overlay(
                Image(systemName: "photo")
                  .foregroundColor(Theme.color.foregroundTertiary)
              )
              .aspectRatio(1, contentMode: .fit)
              .clipped()
          }
        }
        .padding(.top, Theme.spacing.xxs)
      }

      // 3. 底部信息行：时间 + 标签 + 菜单
      HStack(alignment: .center, spacing: Theme.spacing.xs) {
        Text(timeString)
          .font(Theme.font.caption.weight(.medium))
          .foregroundColor(Theme.color.foregroundTertiary)

        if !tags.isEmpty {
          ForEach(tags, id: \.self) { tag in
            Text("#\(tag)")
              .font(Theme.font.caption2)
              .foregroundColor(Theme.color.tagText)
              .padding(.horizontal, Theme.spacing.compact)
              .padding(.vertical, Theme.spacing.xxxs)
              .background(Theme.color.tagText.opacity(0.08))  // 标签增加淡淡的背景
              .cornerRadius(Theme.radius.xs)
          }
        }

        Spacer()

        // 操作菜单
        Menu {
          menuItems
        } label: {
          Image(systemName: "ellipsis")
            .font(.system(size: 14))  // 稍微调大一点便于点击，保持系统图标大小
            .foregroundColor(Theme.color.foregroundTertiary)
            .frame(width: 24, height: 24)
            .contentShape(Rectangle())
        }
      }
      .padding(.top, Theme.spacing.xxs)
    }
    .padding(Theme.spacing.md)  // 舒适的内边距
    .background(Theme.color.cardBackground)
    .cornerRadius(Theme.radius.sm)  // 适度的圆角，平衡锐利与柔和
    // 增加极淡的阴影，营造悬浮感
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
