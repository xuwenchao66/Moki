//
//  TimelineView.swift
//  Moki
//
//  日记时间轴首页
//  展示按日期分组的日记流
//

import SQLiteData
import SwiftUI

struct TimelineView: View {

  // MARK: - Data

  // 从数据库自动拉取所有日记，并按创建时间倒序排列
  @FetchAll(JournalEntry.order { $0.createdAt.desc() })
  private var entries: [JournalEntry]

  // 用于分组展示的数据结构
  struct DailyGroup: Identifiable {
    let id: String  // 使用日期字符串作为 ID
    let date: String
    let entries: [JournalEntry]
  }

  // 按日期分组的计算属性
  var groupedEntries: [DailyGroup] {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    let grouped = Dictionary(grouping: entries) { entry in
      formatter.string(from: entry.createdAt)
    }

    // 按日期倒序排序
    return grouped.keys.sorted(by: >).map { dateString in
      // 组内也按时间倒序 (数据库已经排过序了，但分组后可能乱序，保险起见再排一次)
      let sortedEntries = grouped[dateString]!.sorted { $0.createdAt > $1.createdAt }
      return DailyGroup(id: dateString, date: dateString, entries: sortedEntries)
    }
  }

  // MARK: - View

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      VStack(spacing: 0) {
        // 1. 自定义顶部导航栏
        HStack {
          Button(action: {}) {
            Image(systemName: "line.3.horizontal")
              .font(.title2)
              .foregroundColor(Theme.color.foreground)
          }

          Spacer()

          Text("Moki")
            .font(Theme.font.title3.weight(.bold))
            .foregroundColor(Theme.color.foreground)

          Spacer()

          Button(action: {}) {
            Image(systemName: "magnifyingglass")
              .font(.title2)
              .foregroundColor(Theme.color.foreground)
          }
        }
        .padding(.horizontal, Theme.spacing.lg)
        .padding(.top, Theme.spacing.md)
        .padding(.bottom, Theme.spacing.md)
        .background(Theme.color.background)

        // 2. 滚动内容区
        ScrollView {
          if entries.isEmpty {
            // 空状态
            VStack(spacing: Theme.spacing.lg) {
              Spacer(minLength: 100)
              Image(systemName: "book.closed")
                .font(.system(size: 48))
                .foregroundColor(Theme.color.foregroundTertiary)
              Text("还没有日记")
                .font(Theme.font.body)
                .foregroundColor(Theme.color.foregroundSecondary)
            }
          } else {
            LazyVStack(spacing: 0) {
              ForEach(groupedEntries) { group in
                VStack(spacing: 0) {
                  // 日期头
                  JournalDateHeader(date: group.date)
                    .padding(.top, Theme.spacing.lg)

                  // 当天的日记条目
                  ForEach(group.entries) { entry in
                    JournalItemView(
                      content: entry.text,
                      time: formatTime(entry.createdAt),
                      tags: [],  // 暂时移除 tags 支持
                      images: []  // 暂时移除 photos 支持
                    )
                  }
                }
              }

              Spacer(minLength: 100)  // 底部留白
            }
            .padding(.horizontal, Theme.spacing.lg)
          }
        }
      }
      .background(Theme.color.background)

      // 3. 悬浮按钮 (FAB)
      Button(action: {
        // TODO: 新增日记动作
      }) {
        Image(systemName: "plus")
          .font(.system(size: 24, weight: .medium))
          .foregroundColor(.white)
          .frame(width: 56, height: 56)
          .background(Theme.color.primaryAction)
          .clipShape(Circle())
          .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
      }
      .padding(.trailing, Theme.spacing.lg)
      .padding(.bottom, Theme.spacing.lg)
    }
  }

  // MARK: - Helpers

  private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter.string(from: date)
  }
}

#Preview {
  configureAppDependencies()
  return TimelineView()
}
