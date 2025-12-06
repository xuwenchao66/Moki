//
//  JournalItemView.swift
//  Moki
//
//  日记条目卡片
//  左侧展示日期，右侧为卡片式内容
//

import SwiftUI

struct JournalItemView: View {
  let content: String
  let date: Date
  let tags: [String]
  var images: [String] = []
  var showDate: Bool = true  // 控制是否显示左侧日期
  var onMoreTapped: (() -> Void)? = nil

  var body: some View {
    HStack(alignment: .top, spacing: Theme.spacing.md) {
      // 1. 左侧日期区域
      VStack(alignment: .center, spacing: 2) {
        if showDate {
          Text(dayString)
            .font(.system(size: 24, weight: .bold, design: .serif))
            .foregroundColor(Theme.color.foreground)

          Text(weekdayString)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Theme.color.foregroundSecondary)
        }
      }
      .frame(width: 44)  // 固定宽度，确保时间轴对齐
      .padding(.top, 4)  // 微调顶部对齐

      // 2. 右侧卡片区域
      VStack(alignment: .leading, spacing: Theme.spacing.sm) {
        // 顶部：更多按钮 (如果需要放在右上角，或者跟内容混排)
        // 这里暂时保持简洁，将更多按钮放在右下角或跟随内容?
        // 截图通常更多按钮在卡片右上角或者右下角。
        // 根据之前的布局，更多按钮在底部。
        // 但卡片式设计，右上角放更多按钮比较常见。
        // 让我们把更多按钮放在右上角，如果提供了的话。

        HStack(alignment: .top) {
          Text(content)
            .font(Theme.font.journalBody)
            .foregroundColor(Theme.color.foreground)
            .lineSpacing(Theme.spacing.textLineSpacing)
            .fixedSize(horizontal: false, vertical: true)

          if onMoreTapped != nil {
            Spacer()
            Button(action: { onMoreTapped?() }) {
              Image(systemName: "ellipsis")
                .foregroundColor(Theme.color.foregroundTertiary)
                .padding(.leading, 8)
                .padding(.bottom, 8)  // 增加一点点击区域
            }
          }
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
            .font(Theme.font.caption)  // 或者 .system(size: 12)
            .foregroundColor(Theme.color.foregroundTertiary)

          // 标签
          if !tags.isEmpty {
            ForEach(tags, id: \.self) { tag in
              Text("#\(tag)")
                .font(Theme.font.caption)
                .foregroundColor(Theme.color.foregroundSecondary)
            }
          }
        }
        .padding(.top, 4)
      }
      .padding(Theme.spacing.md)
      .background(Theme.color.cardBackground)
      .cornerRadius(Theme.radius.md)
      .shadow(color: Color.black.opacity(0.02), radius: 2, x: 0, y: 1)  // 极淡的阴影增加层次
    }
    .padding(.horizontal, Theme.spacing.md)  // 整个条目的水平间距
    .padding(.vertical, Theme.spacing.xs)  // 条目间的垂直间距
  }

  // MARK: - Helpers

  private var dayString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    return formatter.string(from: date)
  }

  private var weekdayString: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "EEE"  // 周六
    return formatter.string(from: date)
  }

  private var timeString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
}

#Preview {
  ZStack {
    Theme.color.background.ignoresSafeArea()

    VStack {
      JournalItemView(
        content: "欲望是你跟自己签的协议：在得到你想要的东西之前，你一直不会快乐。",
        date: Date(),
        tags: ["Naval", "智慧"],
        showDate: true,
        onMoreTapped: {}
      )

      JournalItemView(
        content: "下班路上的光影。",
        date: Date().addingTimeInterval(-3600),
        tags: [],
        images: ["1"],
        showDate: false,
        onMoreTapped: {}
      )
    }
  }
}
