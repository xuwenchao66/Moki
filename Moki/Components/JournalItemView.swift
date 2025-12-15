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
    VStack(alignment: .leading, spacing: Theme.spacing.md) {

      // 1. 文字区域 (带引用线)
      HStack(alignment: .top, spacing: Theme.spacing.md) {
        // 装饰竖线 (Identity) - 视觉记忆点
        Capsule()
          .fill(Color(red: 0.75, green: 0.45, blue: 0.35))  // 暖砖红色
          .frame(width: 3)
          .padding(.vertical, 4)  // 稍微内缩，不顶满

        VStack(alignment: .leading, spacing: Theme.spacing.sm) {
          // 正文 - 宋体
          Text(content)
            .font(Theme.font.journalBody)
            .foregroundColor(Theme.color.foreground)
            .lineSpacing(Theme.spacing.textLineSpacing)
            .fixedSize(horizontal: false, vertical: true)

          // 2. 图片区域 (九宫格布局)
          if !images.isEmpty {
            PhotoGridView(images: images)
              .padding(.top, 4)
          }

          // 底部信息 (时间 + Tags)
          HStack(spacing: Theme.spacing.sm) {
            Text(timeString)
              .font(Theme.font.footnote)
              .foregroundColor(Theme.color.foregroundTertiary)
              .tracking(0.5)

            if !tags.isEmpty {
              Text("·")
                .foregroundColor(Theme.color.foregroundTertiary)

              ForEach(tags, id: \.self) { tag in
                Text("#\(tag)")
                  .font(Theme.font.footnote)
                  .foregroundColor(Theme.color.foregroundSecondary)
              }
            }

            Spacer()

            // 菜单
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
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
            }
          }
          .padding(.top, Theme.spacing.xxs)
        }
      }
    }
    .padding(.horizontal, Theme.spacing.md)
    .padding(.vertical, Theme.spacing.sm)
  }

  private var timeString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
}

// 九宫格图片视图
struct PhotoGridView: View {
  let images: [String]
  private let spacing: CGFloat = 4
  private let itemSize: CGFloat = 80  // 小图尺寸

  var body: some View {
    Group {
      if images.count == 1 {
        // 单张图
        SimpleImageView()
          .frame(width: 160, height: 160)  // 单图稍大
          .cornerRadius(4)
      } else if images.count == 4 {
        // 4张图：2x2 排列
        LazyVGrid(
          columns: [
            GridItem(.fixed(itemSize), spacing: spacing),
            GridItem(.fixed(itemSize), spacing: spacing),
          ],
          alignment: .leading,
          spacing: spacing
        ) {
          ForEach(0..<images.count, id: \.self) { _ in
            SimpleImageView()
              .frame(height: itemSize)
              .cornerRadius(4)
          }
        }
      } else {
        // 其他数量：3列排列 (2, 3, 5-9)
        LazyVGrid(
          columns: [
            GridItem(.fixed(itemSize), spacing: spacing),
            GridItem(.fixed(itemSize), spacing: spacing),
            GridItem(.fixed(itemSize), spacing: spacing),
          ],
          alignment: .leading,
          spacing: spacing
        ) {
          ForEach(0..<min(images.count, 9), id: \.self) { _ in
            SimpleImageView()
              .frame(height: itemSize)
              .cornerRadius(4)
          }
        }
      }
    }
  }
}

// 简单的图片占位 View
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
