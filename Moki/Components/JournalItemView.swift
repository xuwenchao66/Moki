//
//  JournalItemView.swift
//  Moki
//
//  日记条目卡片
//  展示内容、时间、标签和可选图片
//

import SwiftUI

struct JournalItemView: View {
  let content: String
  let time: String
  let tags: [String]
  var images: [String] = []
  var onMoreTapped: (() -> Void)? = nil

  var body: some View {
    HStack(alignment: .top, spacing: Theme.spacing.md) {
      // 1. 左侧时间
      Text(time)
        .font(Theme.font.timeStamp)  // 使用 Serif 字体
        .foregroundColor(Theme.color.foregroundSecondary)
        .frame(width: 50, alignment: .leading)  // 固定宽度保证对齐
        .padding(.top, 2)  // 微调顶部对齐，因为 Serif 字体通常基线不同

      // 2. 右侧内容区域
      VStack(alignment: .leading, spacing: Theme.spacing.sm) {
        // 文本内容
        Text(content)
          .font(Theme.font.body)
          .foregroundColor(Theme.color.foreground)
          .lineSpacing(Theme.spacing.compact)
          .fixedSize(horizontal: false, vertical: true)

        // 图片区域
        if !images.isEmpty {
          HStack(spacing: Theme.spacing.sm) {
            ForEach(0..<images.count, id: \.self) { _ in
              RoundedRectangle(cornerRadius: Theme.radius.md)
                .fill(Theme.color.border)
                .overlay(
                  Image(systemName: "photo")
                    .foregroundColor(Theme.color.foregroundSecondary)
                )
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipped()
            }
          }
        }

        // 底部元数据 (标签 + 更多)
        if !tags.isEmpty || onMoreTapped != nil {
          HStack(spacing: Theme.spacing.sm) {
            ForEach(tags, id: \.self) { tag in
              TagCapsule(tag)
            }

            Spacer()

            if let onMoreTapped = onMoreTapped {
              Button(action: onMoreTapped) {
                Image(systemName: "ellipsis")
                  .font(.system(size: 14))
                  .foregroundColor(Theme.color.foregroundTertiary)
                  .padding(Theme.spacing.xxs)
              }
            }
          }
        }
      }
    }
    .padding(.vertical, Theme.spacing.md)
    .frame(maxWidth: .infinity, alignment: .leading)  // 确保占满宽度并左对齐
  }
}

#Preview {
  VStack {
    JournalItemView(
      content: "欲望是你跟自己签的协议：在得到你想要的东西之前，你一直不会快乐。",
      time: "23:42:15",
      tags: ["Naval", "幸福"]
    )

    JournalItemView(
      content: "带图的日记示例",
      time: "12:00:00",
      tags: ["图片"],
      images: ["1", "2"]
    )
  }
  .padding()
}
