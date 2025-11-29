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
  @FetchAll(MokiDiary.order { $0.createdAt.desc() })
  private var entries: [MokiDiary]

  // 仅展示今天的日记
  var todaysEntries: [MokiDiary] {
    let calendar = Calendar.current
    return entries.filter { calendar.isDateInToday($0.createdAt) }
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

          Text(formattedDate(Date()))
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
          if todaysEntries.isEmpty {
            // 空状态
            VStack(spacing: Theme.spacing.lg) {
              Spacer(minLength: 100)
              Image(systemName: "square.and.pencil")
                .font(.system(size: 48))
                .foregroundColor(Theme.color.foregroundTertiary)
              Text("记录当下的想法...")
                .font(Theme.font.body)
                .foregroundColor(Theme.color.foregroundSecondary)
            }
          } else {
            LazyVStack(spacing: 0) {
              ForEach(todaysEntries) { entry in
                JournalItemView(
                  content: entry.text,
                  time: formatTime(entry.createdAt),
                  tags: [],  // 暂时移除 tags 支持
                  images: []  // 暂时移除 photos 支持
                )

                // 分割线 (可选，保持简约可不加，这里为了区分)
                // Divider().padding(.leading, 50)
              }

              Spacer(minLength: 100)  // 底部留白
            }
            .padding(.horizontal, Theme.spacing.lg)
            .padding(.top, Theme.spacing.md)
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
    formatter.dateFormat = "HH:mm"  // 23:42
    return formatter.string(from: date)
  }

  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M月d日"
    return formatter.string(from: date)
  }
}

#Preview {
  // configureAppDependencies() // Preview might not have this
  return TimelineView()
}
