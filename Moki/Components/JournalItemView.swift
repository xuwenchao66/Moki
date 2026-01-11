import SwiftUI

/// 日记条目组件 - 三明治结构
/// Layer 1: 内容层 (Content) - 衬线体,情感优先
/// Layer 2: 媒体层 (Media) - 图片/视频
/// Layer 3: 信息层 (Meta) - 时间+标签,极度弱化
struct JournalItemView: View {
  let content: String
  let date: Date
  let tags: [String]
  var images: [String] = []

  // Callbacks
  var onEditTapped: (() -> Void)? = nil
  var onDeleteTapped: (() -> Void)? = nil

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Layer 1: 内容层 - 纯文字,衬线体
      Text(content)
        .journalBodyStyle()
        .fixedSize(horizontal: false, vertical: true)
        .padding(.bottom, Theme.spacing.md)

      // Layer 2: 媒体层 - 图片
      if !images.isEmpty {
        MediaRowView(images: images)
          .padding(.bottom, Theme.spacing.md)
      }

      // Layer 3: 信息层 - 极度弱化,像书页页码
      HStack(alignment: .center, spacing: Theme.spacing.xs) {
        Text(timeString)
          .font(Theme.font.footnote)
          .foregroundColor(Theme.color.mutedForeground)

        Text("·")
          .font(Theme.font.footnote)
          .foregroundColor(Theme.color.mutedForeground)

        if !tags.isEmpty {
          ForEach(tags, id: \.self) { tag in
            TagChip(name: tag, mode: .read)
          }
        }

        Spacer(minLength: 0)
      }
    }
    .contentShape(Rectangle())
    .contextMenu {
      if let onEditTapped {
        Button(action: onEditTapped) { Label("编辑", systemImage: "pencil") }
      }
      if let onDeleteTapped {
        Button(role: .destructive, action: onDeleteTapped) {
          Label("删除", systemImage: "trash")
        }
      }
    }
  }

  private var timeString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
}


/// 媒体展示组件 - 圆角矩形,通栏显示
private struct MediaRowView: View {
  let images: [String]

  var body: some View {
    let count = images.count
    switch count {
    case 1:
      MediaPlaceholderView()
        .aspectRatio(4 / 3, contentMode: .fill)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radius.xl, style: .continuous))

    case 2:
      HStack(spacing: Theme.spacing.xs) {
        MediaPlaceholderView()
        MediaPlaceholderView()
      }
      .frame(height: 150)
      .clipShape(RoundedRectangle(cornerRadius: Theme.radius.xl, style: .continuous))

    default:
      LazyVGrid(
        columns: [GridItem(.flexible(), spacing: Theme.spacing.xs), GridItem(.flexible())],
        spacing: Theme.spacing.xs
      ) {
        ForEach(0..<min(count, 6), id: \.self) { _ in
          MediaPlaceholderView()
            .aspectRatio(1, contentMode: .fill)
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: Theme.radius.xl, style: .continuous))
    }
  }
}

private struct MediaPlaceholderView: View {
  var body: some View {
    ZStack {
      Theme.color.muted
      Text("Image")
        .font(.system(size: 14, weight: .regular, design: .default))
        .foregroundColor(Theme.color.mutedForeground)
    }
    .clipped()
  }
}
