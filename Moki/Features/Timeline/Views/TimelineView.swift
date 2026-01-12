import Dependencies
import SQLiteData
import SwiftUI

struct TimelineView: View {
  @Binding var isSideMenuPresented: Bool
  @State private var isViewActive = false
  @State private var showAddEntry = false
  private let diaryService = DiaryService()

  // 1. 真实数据源
  @FetchAll(
    MokiDiary
      .where { $0.deletedAt == nil }
      .order { $0.createdAt.desc() }
  )
  private var dbEntries: [MokiDiary]

  // 2. 数据源切换
  // 💡 Tip: 取消注释下面一行即可使用 Mock 数据调试 UI
  private var entries: [MokiDiary] {
    return mockEntries  // 🟢 Mock Data
    // return dbEntries  // 🔵 Real Data
  }

  // 3. Mock 数据适配
  private var mockEntries: [MokiDiary] {
    MockEntry.examples.map { mock in
      let tagsJson = mock.tags.map { "\"\($0)\"" }.joined(separator: ",")
      let imagesJson = mock.images.map { "\"\($0)\"" }.joined(separator: ",")
      let metadata = "{\"tags\":[\(tagsJson)], \"images\":[\(imagesJson)]}"

      return MokiDiary(
        id: mock.id,
        text: mock.content,
        createdAt: mock.date,
        timeZone: TimeZone.current.identifier,
        metadata: metadata
      )
    }
  }

  // MARK: - Formatters

  private static let monthDayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "M月d日"
    return formatter
  }()

  private static let weekdayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "EEE"  // 周日/周一…
    return formatter
  }()

  private static let yearFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "yyyy"
    return formatter
  }()

  // MARK: - View

  var body: some View {
    ZStack(alignment: .bottom) {
      if entries.isEmpty {
        EmptyDiaryView {
          showAddEntry = true
        }
      } else {
        ScrollView {
          LazyVStack(alignment: .leading, spacing: 0) {
            // 顶部呼吸
            Color.clear.frame(height: Theme.spacing.lg)

            ForEach(dayGroups, id: \.id) { group in
              // 日期头部
              dayHeader(for: group.day)
                .padding(.horizontal, Theme.spacing.lg)

              // 该天的所有条目
              ForEach(group.entries, id: \.id) { entry in
                let extra = parseMetadata(entry.metadata)

                JournalItemView(
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
                .padding(.bottom, Theme.spacing.md)
              }

              // 天与天之间的大留白
              Color.clear
                .frame(height: Theme.spacing.xl)
            }
          }
        }
        .background(Theme.color.background)
      }

      // Dock View
      TimelineDock(
        onMenuTapped: { isSideMenuPresented.toggle() },
        onAddTapped: { showAddEntry = true }
      )
    }
    .background(Theme.color.background)
    .navigationDestination(isPresented: $showAddEntry) {
      EditView()
    }
    .onAppear { isViewActive = true }
    .onDisappear { isViewActive = false }
    .sideMenuGesture(enabled: isViewActive)
  }

  // MARK: - Helpers

  private struct DayGroup: Identifiable {
    let id: String
    let day: Date
    let entries: [MokiDiary]
  }

  private var dayGroups: [DayGroup] {
    guard !entries.isEmpty else { return [] }

    // 简洁、好维护：直接按“当天 00:00”分组，再按日期倒序输出
    let grouped = Dictionary(grouping: entries) { entry in
      Calendar.current.startOfDay(for: entry.createdAt)
    }

    return grouped.keys
      .sorted(by: >)
      .map { day in
        let list = (grouped[day] ?? []).sorted { $0.createdAt > $1.createdAt }
        return DayGroup(id: day.toMokiDateString(), day: day, entries: list)
      }
  }

  /// 日期头部 - 大小对比设计
  /// 大数字(Day) + 小辅助信息(Month/Weekday)
  /// 这是平面设计中产生高级感的最简单技巧
  private func dayHeader(for date: Date) -> some View {
    let day = Calendar.current.component(.day, from: date)
    let month = Calendar.current.component(.month, from: date)
    let weekday = Self.weekdayFormatter.string(from: date)
    let year = Calendar.current.component(.year, from: date)
    let currentYear = Calendar.current.component(.year, from: Date())
    let isPastYear = year != currentYear
    let dayString = String(format: "%02d", day)

    return HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.xs) {
      // 巨大的数字 - 视觉锚点
      Text(dayString)
        .font(Theme.font.dateLarge)
        .foregroundColor(Theme.color.dateLargeForeground)

      // 小辅助信息
      HStack(spacing: 0) {
        Text("\(month)月 / \(weekday)")
        if isPastYear {
          Text(" · \(String(year))")
            .foregroundColor(Theme.color.mutedForeground.opacity(0.8))
        }
      }
      .font(Theme.font.dateSmall)
      .foregroundColor(Theme.color.mutedForeground)
      .offset(y: -2)

      Spacer()
    }
  }

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

#Preview {
  NavigationStack {
    TimelineView(isSideMenuPresented: .constant(false))
  }
}
