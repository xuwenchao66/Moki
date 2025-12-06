import SQLiteData
import SwiftUI

struct TimelineView: View {
  @Binding var isSideMenuPresented: Bool

  // MARK: - Data

  @State private var showAddEntry = false

  // 从数据库自动拉取所有日记，并按创建时间倒序排列
  @FetchAll(MokiDiary.order { $0.createdAt.desc() })
  private var entries: [MokiDiary]

  // 临时 Mock 数据模型
  struct MockEntry: Identifiable {
    let id = UUID()
    let content: String
    let date: Date
    let images: [String]
    let tags: [String]
  }

  // 硬编码的演示数据
  private var mockEntries: [MockEntry] {
    let now = Date()
    let calendar = Calendar.current

    // 辅助函数：生成今天指定时间的 Date 对象
    func time(_ dayOffset: Int, _ hour: Int, _ minute: Int) -> Date {
      let day = calendar.date(byAdding: .day, value: dayOffset, to: now) ?? now
      return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day) ?? day
    }

    return [
      MockEntry(
        content: "欲望是你跟自己签的协议：在得到你想要的东西之前，你一直不会快乐。",
        date: time(0, 23, 42),
        images: [],
        tags: ["Naval", "智慧"]
      ),
      MockEntry(
        content: "下班路上的光影，治愈了一整天的疲惫。",
        date: time(0, 20, 15),
        images: ["1"],
        tags: ["摄影"]
      ),
      MockEntry(
        content: "趁着午休时间去公园走了走，秋天真的太美了。\n\n阳光透过树叶洒下来，像是给地面铺了一层金箔。空气里有桂花的香味，深呼吸，感觉肺都被净化了。",
        date: time(0, 12, 30),
        images: ["1", "2"],
        tags: []
      ),
      MockEntry(
        content: "早安 Moki。新的一天，保持专注。",
        date: time(0, 08, 00),
        images: [],
        tags: ["早安"]
      ),
      // 添加一些昨天的数据来演示分组
      MockEntry(
        content: "昨天的记录，测试时间线分组功能。",
        date: time(-1, 22, 00),
        images: [],
        tags: ["测试"]
      ),
    ]
  }

  // 按月份分组的数据
  private var groupedEntries: [(month: String, entries: [MockEntry])] {
    let grouped = Dictionary(grouping: mockEntries) { entry -> String in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy.MM"
      return formatter.string(from: entry.date)
    }

    return grouped.keys.sorted(by: >).map { key in
      (month: key, entries: grouped[key]!.sorted { $0.date > $1.date })
    }
  }

  // MARK: - View

  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottomTrailing) {
        ScrollView {
          LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            ForEach(groupedEntries, id: \.month) { group in
              Section(header: monthHeader(group.month)) {
                ForEach(Array(group.entries.enumerated()), id: \.element.id) { index, entry in
                  // 判断是否显示日期：如果是第一条，或者跟上一条不是同一天，则显示
                  let showDate = shouldShowDate(entries: group.entries, currentIndex: index)

                  JournalItemView(
                    content: entry.content,
                    date: entry.date,
                    tags: entry.tags,
                    images: entry.images,
                    showDate: showDate,
                    onMoreTapped: {
                      // TODO: More Action
                    }
                  )
                }
              }
            }

            Spacer(minLength: 100)  // 底部留白
          }
          .padding(.top, Theme.spacing.md)
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
      .navigationTitle("")  // 去掉标题
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
          .foregroundColor(Theme.color.primaryAction)  // 改为主要黑色
        }

        ToolbarItem(placement: .primaryAction) {
          Button {
            // TODO: 搜索逻辑
          } label: {
            Image(systemName: "magnifyingglass")
          }
          .toolbarIconStyle()
          .foregroundColor(Theme.color.primaryAction)  // 改为主要黑色
        }
      }
    }
    .sheet(isPresented: $showAddEntry) {
      NavigationStack {
        EditView()
      }
    }
  }

  // MARK: - Helpers

  private func monthHeader(_ month: String) -> some View {
    HStack {
      Text(month)
        .font(Theme.font.title2)  // 比如 2025.12
        .foregroundColor(Theme.color.foreground)
        .padding(.horizontal, Theme.spacing.lg)
        .padding(.vertical, Theme.spacing.sm)
      Spacer()
    }
    .background(Theme.color.background)  // 确保吸顶时遮挡内容
  }

  /// 判断当前条目是否需要显示日期
  private func shouldShowDate(entries: [MockEntry], currentIndex: Int) -> Bool {
    if currentIndex == 0 { return true }

    let currentEntry = entries[currentIndex]
    let previousEntry = entries[currentIndex - 1]

    let calendar = Calendar.current
    return !calendar.isDate(currentEntry.date, inSameDayAs: previousEntry.date)
  }
}

#Preview {
  // configureAppDependencies() // Preview might not have this
  return TimelineView(isSideMenuPresented: .constant(false))
}
