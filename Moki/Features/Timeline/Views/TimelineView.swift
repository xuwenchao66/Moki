import SQLiteData
import SwiftUI

struct TimelineView: View {
  @Binding var isSideMenuPresented: Bool

  // MARK: - Data

  @State private var showAddEntry = false

  // 从数据库自动拉取所有日记，并按创建时间倒序排列
  @FetchAll(MokiDiary.order { $0.createdAt.desc() })
  private var entries: [MokiDiary]

  // 硬编码的演示数据
  private var mockEntries: [MockEntry] {
    return MockEntry.examples
  }

  // 按月份和日期分组的数据
  private var groupedEntries: [(month: String, days: [(date: Date, entries: [MokiDiary])])] {
    // 1. 按月份分组
    let byMonth = Dictionary(grouping: entries) { entry -> String in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy.MM"
      return formatter.string(from: entry.createdAt)
    }

    // 2. 月份倒序
    return byMonth.keys.sorted(by: >).map { monthKey in
      let monthEntries = byMonth[monthKey]!

      // 3.按日期分组
      let byDay = Dictionary(grouping: monthEntries) { entry -> String in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: entry.createdAt)
      }

      // 4. 日期倒序
      let sortedDays = byDay.keys.sorted(by: >).map {
        dayKey -> (date: Date, entries: [MokiDiary]) in
        let dayEntries = byDay[dayKey]!.sorted { $0.createdAt > $1.createdAt }
        // 使用当天的第一条数据的时间作为该组的 Date Key
        return (date: dayEntries.first!.createdAt, entries: dayEntries)
      }

      return (month: monthKey, days: sortedDays)
    }
  }

  // MARK: - View

  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottomTrailing) {
        ScrollView {
          // pinnedViews: [.sectionHeaders] 实现月份吸顶
          LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            ForEach(groupedEntries, id: \.month) { monthGroup in
              Section(header: MonthHeaderView(title: monthGroup.month)) {

                // 月份内的日期列表
                ForEach(monthGroup.days, id: \.date) { dayGroup in
                  HStack(alignment: .top, spacing: Theme.spacing.md) {
                    // 左侧：日期 (整个分组共用一个日期显示)
                    JournalDateView(date: dayGroup.date)
                      .padding(.top, Theme.spacing.md)  // 微调顶部对齐，与卡片内容对齐

                    // 右侧：日记卡片列表
                    VStack(spacing: Theme.spacing.sm) {
                      ForEach(dayGroup.entries) { entry in
                        JournalCardView(
                          content: entry.text,
                          date: entry.createdAt,
                          tags: [],  // TODO: Tags support
                          images: [],  // TODO: Images support
                          onMoreTapped: {
                            // TODO: More Action
                          }
                        )
                      }
                    }
                  }
                  .padding(.horizontal, Theme.spacing.md)
                  .padding(.bottom, Theme.spacing.md2)  // 不同日期之间的间距
                }
              }
            }

            Spacer(minLength: 80)  // 底部留白，避免被 FAB 遮挡
          }
        }
        .background(Theme.color.background)

        // 3. 悬浮按钮 (FAB)
        Button(action: {
          showAddEntry = true
        }) {
          Image(systemName: "plus")
            .font(.system(size: 22, weight: .light))
            .foregroundColor(Theme.color.primaryActionForeground)
            .frame(width: 48, height: 48)
            .background(Theme.color.primaryAction)
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        }
        .padding(.trailing, Theme.spacing.lg)
        .padding(.bottom, Theme.spacing.lg)
      }
      .background(Theme.color.background)
      .navigationTitle("Moki")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            withAnimation {
              isSideMenuPresented.toggle()
            }
          } label: {
            Image(systemName: "line.3.horizontal")
          }
          .toolbarIconStyle()
        }

        ToolbarItem(placement: .primaryAction) {
          Button {
            // TODO: 搜索逻辑
          } label: {
            Image(systemName: "magnifyingglass")
          }
          .toolbarIconStyle()
        }
      }
    }
    .sheet(isPresented: $showAddEntry) {
      NavigationStack {
        EditView()
      }
    }
  }
}

// MARK: - Components

/// 吸顶的月份标题
struct MonthHeaderView: View {
  let title: String

  var body: some View {
    HStack {
      Text(title)
        .font(Theme.font.dateTitle)
        .foregroundColor(Theme.color.foreground)
        .padding(.horizontal, Theme.spacing.md2)
        .padding(.vertical, Theme.spacing.sm)
      Spacer()
    }
    .background(Theme.color.background.opacity(0.95))
    .overlay(
      Rectangle()
        .frame(height: 0.5)
        .foregroundColor(Theme.color.border.opacity(0.3))
        .padding(.horizontal, Theme.spacing.md2),
      alignment: .bottom
    )
  }
}

#Preview {
  return TimelineView(isSideMenuPresented: .constant(false))
}
