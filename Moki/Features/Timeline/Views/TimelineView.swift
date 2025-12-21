import Dependencies
import SQLiteData
import SwiftUI

struct TimelineView: View {
  @Binding var isSideMenuPresented: Bool

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
    NavigationStack {
      ZStack(alignment: .bottomTrailing) {
        if entries.isEmpty {
          EmptyStateView(
            title: "还没有记录",
            message: "点击 + 创建你的独家记忆",
            action: { showAddEntry = true }
          )
        } else {
          ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
              // 顶部呼吸
              Color.clear.frame(height: Theme.spacing.md)

              ForEach(dayGroups, id: \.id) { group in
                Section(
                  header:
                    dayHeader(for: group.day)
                    .padding(.top, Theme.spacing.xs)
                    .padding(.bottom, Theme.spacing.lg2)
                    .padding(.horizontal, Theme.spacing.lg)
                    .background(Theme.color.background)
                ) {
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
                    .padding(.horizontal, Theme.spacing.lg)
                    .padding(.bottom, Theme.spacing.xxl)
                  }

                  // 天与天之间的大留白 - 代替分割线
                  Color.clear
                    .frame(height: Theme.spacing.xl)
                }
              }

              Spacer(minLength: 80)
            }
          }
          .background(Theme.color.background)
        }

        // FAB - 深色按钮
        Button(action: { showAddEntry = true }) {
          Image(systemName: "plus")
            .font(.system(size: 22, weight: .light))
            .foregroundColor(Theme.color.primaryForeground)
            .frame(width: 52, height: 52)
            .background(Theme.color.cardForeground)
            .clipShape(Circle())
            .shadow(
              color: Theme.shadow.md.color, radius: Theme.shadow.md.radius, x: Theme.shadow.md.x,
              y: Theme.shadow.md.y)
        }
        .padding(.trailing, Theme.spacing.lg)
        .padding(.bottom, Theme.spacing.lg)
      }
      .background(Theme.color.background)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("Moki")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            withAnimation { isSideMenuPresented.toggle() }
          } label: {
            Image(systemName: "line.3.horizontal")
              .foregroundColor(Theme.color.foreground)
          }
        }

        ToolbarItem(placement: .primaryAction) {
          Button {
          } label: {
            Image(systemName: "magnifyingglass")
              .foregroundColor(Theme.color.foreground)
          }
        }
      }
      .navigationDestination(isPresented: $showAddEntry) {
        EditView().sideMenuGesture(enabled: false)
      }
    }
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

    return HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.xs) {
      // 巨大的数字 - 视觉锚点
      Text("\(day)")
        .font(Theme.font.dateLarge)
        .foregroundColor(Theme.color.foreground)
        .tracking(-0.5)

      // 小辅助信息
      Text("\(month)月 / \(weekday)")
        .font(Theme.font.dateSmall)
        .foregroundColor(Theme.color.mutedForeground)
        .textCase(.uppercase)

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
  TimelineView(isSideMenuPresented: .constant(false))
}
