import SwiftUI

/// 左侧日期组件
struct JournalDateView: View {
  let date: Date

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Text(dayString)
        .font(.system(size: 20, weight: .semibold, design: .default))
        .foregroundColor(Theme.color.foreground)

      Text(weekdayString)
        .font(.system(size: 10, weight: .regular))
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
    formatter.locale = Locale(identifier: "zh_CN")  // 使用英文星期更显高级感
    formatter.dateFormat = "EEE"
    return formatter.string(from: date)
  }
}

/// 右侧内容组件 (去卡片化，更轻量)
struct JournalCardView: View {
  let content: String
  let date: Date
  let tags: [String]
  var images: [String] = []

  // Callbacks
  var onEditTapped: (() -> Void)? = nil
  var onDeleteTapped: (() -> Void)? = nil

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      // 1. 内容区域
      Text(content)
        .font(Theme.font.journalBody)
        .foregroundColor(Theme.color.foreground)
        .lineSpacing(6)  // 优化行间距
        .fixedSize(horizontal: false, vertical: true)

      // 2. 图片区域
      if !images.isEmpty {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
          ForEach(0..<images.count, id: \.self) { _ in
            RoundedRectangle(cornerRadius: 6)
              .fill(Theme.color.cardBackground)
              .overlay(
                Image(systemName: "photo")
                  .foregroundColor(Theme.color.foregroundTertiary)
              )
              .aspectRatio(1, contentMode: .fit)
              .clipped()
          }
        }
        .padding(.top, 4)
      }

      // 3. 底部信息行：时间 + 标签 + 菜单
      HStack(alignment: .center, spacing: 6) {
        Text(timeString)
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(Theme.color.foregroundTertiary)

        if !tags.isEmpty {
          ForEach(tags, id: \.self) { tag in
            Text("#\(tag)")
              .font(.system(size: 11))
              .foregroundColor(Theme.color.tagText)
          }
        }

        Spacer()

        // 操作菜单 (更隐蔽)
        Menu {
          menuItems
        } label: {
          Image(systemName: "ellipsis")
            .font(.system(size: 12))
            .foregroundColor(Theme.color.border)  // 非常淡的颜色，降低视觉干扰
            .frame(width: 20, height: 20)
            .contentShape(Rectangle())
        }
      }
      .padding(.top, 2) // 内容和元数据之间稍微拉开一点点
    }
    .padding(.vertical, 4)
    // 移除原有的卡片背景和阴影，回归纯粹的内容
    .contentShape(Rectangle())
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
