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
    // 使用 ZStack 实现时间线穿插效果
    ZStack(alignment: .topLeading) {
      // 1. 左侧时间线 (虚线/实线)
      // 位置：距离左边一定距离 (e.g. 24pt)
      Rectangle()
        .fill(Theme.color.border.opacity(0.5))  // 浅浅灰色
        .frame(width: 1)
        .padding(.leading, 24)  // 线的位置
        .padding(.top, 16)  // 从顶部稍微下来一点，避免连接到上面太紧？或者不需要

      // 2. 内容区域
      VStack(alignment: .leading, spacing: 12) {
        // 时间胶囊 (作为时间线上的点)
        // 使用 background 遮挡住后面的线
        Text(dateTimeString)
          .font(.system(size: 13, weight: .medium, design: .monospaced))
          .foregroundColor(Theme.color.foregroundSecondary)
          .padding(.horizontal, 12)
          .padding(.vertical, 6)
          .background(Theme.color.background)  // 遮挡线
          .overlay(
            Capsule()
              .stroke(Theme.color.border.opacity(0.3), lineWidth: 1)
          )
          .clipShape(Capsule())
          // 让胶囊的左侧一部分覆盖在线上
          // 假设线在 x=24。胶囊如果左对齐，padding(.leading, 12)，那胶囊左边缘在 x=12，胶囊内部就在 x=24 处。
          .padding(.leading, 12)

        // 正文内容 (缩进以避开左侧时间线)
        VStack(alignment: .leading, spacing: 12) {
          Text(content)
            .font(Theme.font.journalBody)
            .foregroundColor(Theme.color.foreground)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)

          // 图片区
          if !images.isEmpty {
            MediaGridView(images: images)
              .padding(.top, 2)
          }

          // 底部标签与操作栏
          HStack(spacing: 8) {
            if !tags.isEmpty {
              ForEach(tags, id: \.self) { tag in
                Text("#\(tag)")
                  .font(.system(size: 12, weight: .regular))
                  .foregroundColor(Theme.color.accent)
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
        .padding(.leading, 44)  // 内容缩进 (24 + 20)
        .padding(.bottom, 24)  // 底部间距
      }
    }
    .padding(.horizontal, Theme.spacing.md)
  }

  // 格式：12.19 14:20 2025
  private var dateTimeString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM.dd HH:mm yyyy"
    return formatter.string(from: date)
  }
}

/// 参考 X 的媒体布局（1/2/3/4 特殊排布；>4 退化为 3 列网格）
struct MediaGridView: View {
  let images: [String]
  private let spacing: CGFloat = 2
  private let cornerRadius: CGFloat = 16

  var body: some View {
    GeometryReader { proxy in
      let w = proxy.size.width
      let count = min(images.count, 9)

      Group {
        switch count {
        case 1:
          mediaCell()
            .frame(width: w, height: max(180, w * 0.56))  // 16:9-ish

        case 2:
          HStack(spacing: spacing) {
            mediaCell()
            mediaCell()
          }
          .frame(width: w, height: max(200, w * 0.56))

        case 3:
          // 1 大 + 2 叠（X 常见样式）
          HStack(spacing: spacing) {
            mediaCell()
            VStack(spacing: spacing) {
              mediaCell()
              mediaCell()
            }
          }
          .frame(width: w, height: max(240, w * 0.70))

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
          .frame(width: w, height: max(240, w * 0.70))

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
          .frame(width: w)
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
    .frame(height: mediaHeight(for: min(images.count, 9)))
    .clipped()
  }

  private func mediaCell() -> some View {
    SimpleImageView()
      .clipped()
  }

  private func mediaHeight(for count: Int) -> CGFloat {
    switch count {
    case 1: return 220
    case 2: return 220
    case 3: return 280
    case 4: return 280
    default: return 280
    }
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
    .aspectRatio(1, contentMode: .fill)
    .clipped()
  }
}
