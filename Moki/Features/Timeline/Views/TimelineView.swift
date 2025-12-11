import Dependencies
import SQLiteData
import SwiftUI

struct TimelineView: View {
  @Binding var isSideMenuPresented: Bool

  @State private var showAddEntry = false
  private let diaryService = DiaryService()

  // 1. 真实数据源 (Database) - 数据库层面过滤未删除的日记
  @FetchAll(
    MokiDiary
      .where { $0.deletedAt == nil }
      .order { $0.createdAt.desc() }
  )
  private var dbEntries: [MokiDiary]

  // 2. 数据源切换 (Data Source Switch)
  // 💡 Tip: 取消注释下面一行即可使用 Mock 数据调试 UI
  private var entries: [MokiDiary] {
    return mockEntries  // 🟢 Mock Data
    // return dbEntries  // 🔵 Real Data
  }

  // 3. Mock 数据适配 (Mock Adapter)
  private var mockEntries: [MokiDiary] {
    MockEntry.examples.map { mock in
      // 简单的 JSON 构造
      let tagsJson = mock.tags.map { "\"\($0)\"" }.joined(separator: ",")
      let imagesJson = mock.images.map { "\"\($0)\"" }.joined(separator: ",")
      let metadata = "{\"tags\":[\(tagsJson)], \"images\":[\(imagesJson)]}"

      return MokiDiary(
        id: mock.id,
        text: mock.content,
        createdAt: mock.date,
        metadata: metadata
      )
    }
  }

  // MARK: - Formatters

  // 缓存 Formatter 以避免在循环中频繁创建，极大提升分组性能
  private static let monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM"
    return formatter
  }()

  private static let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  // 按月份和日期分组的数据
  private var groupedEntries: [(month: String, days: [(date: Date, entries: [MokiDiary])])] {
    // 1. 按月份分组
    let byMonth = Dictionary(grouping: entries) { entry -> String in
      return Self.monthFormatter.string(from: entry.createdAt)
    }

    // 2. 月份倒序
    return byMonth.keys.sorted(by: >).map { monthKey in
      let monthEntries = byMonth[monthKey]!

      // 3.按日期分组
      let byDay = Dictionary(grouping: monthEntries) { entry -> String in
        return Self.dayFormatter.string(from: entry.createdAt)
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
        if entries.isEmpty {
          EmptyStateView(
            title: "还没有记录",
            message: "点击 + 创建你的独家记忆",
          ) {
            showAddEntry = true
          }
        } else {
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
                        .padding(.top, Theme.spacing.sm)

                      // 右侧：日记卡片列表
                      VStack(spacing: Theme.spacing.sm) {
                        ForEach(dayGroup.entries) { entry in
                          let extra = parseMetadata(entry.metadata)
                          JournalCardView(
                            content: entry.text,
                            date: entry.createdAt,
                            tags: extra.tags,
                            images: extra.images,
                            onEditTapped: {
                              // TODO: Edit Action
                            },
                            onDeleteTapped: {
                              diaryService.delete(entry)
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
        }

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
      .navigationDestination(isPresented: $showAddEntry) {
        EditView().sideMenuGesture(enabled: false)
      }
    }
  }
  // MARK: - Helpers

  private func parseMetadata(_ json: String) -> (tags: [String], images: [String]) {
    guard let data = json.data(using: .utf8),
      let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else {
      return ([], [])
    }
    let tags = dict["tags"] as? [String] ?? []
    let images = dict["images"] as? [String] ?? []
    return (tags, images)
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
