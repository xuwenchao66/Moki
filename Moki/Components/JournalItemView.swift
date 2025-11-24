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
    VStack(alignment: .leading, spacing: Theme.spacing.md) {
      // 1. 文本内容 (大号，深色)
      Text(content)
        .font(Theme.font.body)
        .foregroundColor(Theme.color.foreground)
        .lineSpacing(6)
        .fixedSize(horizontal: false, vertical: true)

      // 2. 图片区域 (模拟)
      if !images.isEmpty {
        HStack(spacing: Theme.spacing.sm) {
          ForEach(0..<images.count, id: \.self) { _ in
            RoundedRectangle(cornerRadius: Theme.radius.md)
              .fill(Theme.color.border)  // 占位颜色
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

      // 3. 底部元数据 (时间 + 标签)
      HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.sm) {
        Text(time)
          .font(Theme.font.caption2)
          .foregroundColor(Theme.color.foregroundTertiary)

        ForEach(tags, id: \.self) { tag in
          TagCapsule(tag)
        }

        Spacer()

        // 更多操作菜单
        Button(action: { onMoreTapped?() }) {
          Image(systemName: "ellipsis")
            .font(.system(size: 14))
            .foregroundColor(Theme.color.foregroundTertiary)
            .padding(4)  // 增加点击区域
        }
      }
    }
    .padding(.vertical, Theme.spacing.md)
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
