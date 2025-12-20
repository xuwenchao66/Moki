import SwiftUI

struct JournalItemView: View {
  let content: String
  let date: Date
  let tags: [String]
  var images: [String] = []

  // 新增控制参数
  var isLast: Bool = false

  // Callbacks
  var onEditTapped: (() -> Void)? = nil
  var onDeleteTapped: (() -> Void)? = nil

  var body: some View {
    HStack(alignment: .top, spacing: 0) {
      // 1. 时间线区域
      ZStack(alignment: .top) {
        Rectangle()
          .fill(Theme.color.border)
          .frame(width: 1)
          .padding(.top, 10)
          .padding(.bottom, isLast ? Theme.spacing.lg + 3 : -10)

        // 圆点
        Circle()
          .fill(Theme.color.border)
          .frame(width: 8, height: 8)
          .padding(.top, 4)
      }
      .frame(width: 12)
      .padding(.leading, Theme.spacing.lg)

      // 2. 内容区域
      VStack(alignment: .leading, spacing: Theme.spacing.sm) {
        Text(content)
          .font(Theme.font.journalBody)
          .foregroundColor(Theme.color.foreground)
          .lineSpacing(4)
          .fixedSize(horizontal: false, vertical: true)

        // 图片区
        if !images.isEmpty {
          MediaGridView(images: images)
            .padding(.top, Theme.spacing.xxs)
        }

        // 底部标签与操作栏
        HStack(spacing: Theme.spacing.xs) {
          Text(timeString)
            .font(.system(size: 12, weight: .medium, design: .monospaced))
            .foregroundColor(Theme.color.foregroundSecondary)
            .padding(.trailing, 4)

          if !tags.isEmpty {
            ForEach(tags, id: \.self) { tag in
              Text("#\(tag)")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Theme.color.foregroundSecondary)
            }
          }

          Spacer()

          Menu {
            if let onEditTapped {
              Button(action: onEditTapped) { Label("编辑", systemImage: "pencil") }
            }
            if let onDeleteTapped {
              Button(role: .destructive, action: onDeleteTapped) {
                Label("删除", systemImage: "trash")
              }
            }
          } label: {
            Image(systemName: "ellipsis")
              .font(.system(size: 16))
              .foregroundColor(Theme.color.foregroundTertiary)
              .frame(width: 32, height: 18)
              .contentShape(Rectangle())
          }
        }
      }
      .padding(.leading, Theme.spacing.sm)
      .padding(.bottom, Theme.spacing.lg)
      .padding(.trailing, Theme.spacing.md)
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
      Color(red: 0.94, green: 0.94, blue: 0.94)  // 浅灰背景
      Image(systemName: "photo")
        .foregroundColor(Color.gray.opacity(0.5))
        .font(.title3)
    }
    .clipped()
  }
}
