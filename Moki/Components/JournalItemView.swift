import SwiftUI

struct JournalItemView: View {
  let content: String
  let date: Date
  let tags: [String]
  var images: [String] = []

  // Callbacks
  var onEditTapped: (() -> Void)? = nil
  var onDeleteTapped: (() -> Void)? = nil

  var body: some View {
    HStack(alignment: .top, spacing: 14) {
      // 2pt 左侧边线（HTML：默认透明，hover 才变色；iOS 无 hover，这里保留布局骨架）
      Rectangle()
        .fill(Color.clear)
        .frame(width: 2)

      VStack(alignment: .leading, spacing: Theme.spacing.xxs) {
        Text(content)
          .font(Theme.font.journalBody)
          .foregroundColor(Theme.color.foreground)
          .lineSpacing(Theme.spacing.textLineSpacing)
          .fixedSize(horizontal: false, vertical: true)

        if !images.isEmpty {
          MediaGridView(images: images)
            .padding(.top, Theme.spacing.xxs)
        }

        HStack(spacing: Theme.spacing.md) {
          Text(timeString)
            .font(Theme.font.caption)
            .foregroundColor(Theme.color.mutedForeground)

          if !tags.isEmpty {
            ForEach(tags, id: \.self) { tag in
              Text(tag)
                .font(Theme.font.caption)
                .foregroundColor(Theme.color.mutedForeground)
            }
          }
          Spacer()
        }
        .padding(.top, Theme.spacing.xxs)
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

  // 格式：14:20
  private var timeString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
}

/// 参考 X 的媒体布局（1/2/3/4 特殊排布；>4 退化为 3 列网格）
struct MediaGridView: View {
  let images: [String]
  private let spacing: CGFloat = 2
  private let cornerRadius: CGFloat = 12

  var body: some View {
    let count = min(images.count, 9)

    Group {
      switch count {
      case 1:
        mediaCell()
          .aspectRatio(16 / 9, contentMode: .fit)

      case 2:
        HStack(spacing: spacing) {
          mediaCell()
          mediaCell()
        }
        .aspectRatio(16 / 9, contentMode: .fit)

      case 3:
        // 1 大 + 2 叠（X 常见样式）
        HStack(spacing: spacing) {
          mediaCell()
          VStack(spacing: spacing) {
            mediaCell()
            mediaCell()
          }
        }
        .aspectRatio(3 / 2, contentMode: .fit)

      case 4:
        // 2x2
        VStack(spacing: spacing) {
          HStack(spacing: spacing) {
            mediaCell()
            mediaCell()
          }
          HStack(spacing: spacing) {
            mediaCell()
            mediaCell()
          }
        }
        .aspectRatio(3 / 2, contentMode: .fit)

      default:
        // 5-9：3 列网格（类似 X 的多图）
        LazyVGrid(
          columns: [
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
          ],
          spacing: spacing
        ) {
          ForEach(0..<count, id: \.self) { _ in
            mediaCell()
              .aspectRatio(1, contentMode: .fill)
          }
        }
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
  }

  private func mediaCell() -> some View {
    SimpleImageView()
      .clipped()
  }
}

// 简单的图片占位 View（后续接真图时替换这里）
struct SimpleImageView: View {
  var body: some View {
    ZStack {
      Theme.color.muted
      Image(systemName: "photo")
        .foregroundColor(Theme.color.mutedForeground)
        .font(.title3)
    }
    .clipped()
  }
}
