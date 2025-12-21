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
                    .padding(.top, Theme.spacing.sm)
                    .padding(.bottom, Theme.spacing.md2)
                    .padding(.horizontal, Theme.spacing.md2)
                    .background(Theme.color.background)
                ) {
                  ForEach(Array(group.entries.enumerated()), id: \.element.id) { index, entry in
                    let extra = parseMetadata(entry.metadata)
                    let isLast = index == group.entries.count - 1

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
                    .padding(.horizontal, Theme.spacing.md2)
                    .padding(.bottom, Theme.spacing.lg)

                    if !isLast {
                      Rectangle()
                        .fill(Theme.color.border)
                        .frame(height: 1)
                        .padding(.horizontal, Theme.spacing.md2)
                        .padding(.bottom, Theme.spacing.lg)
                    }
                  }

                  // 组与组之间的呼吸（同一天最后一条不需要额外分割线）
                  Color.clear
                    .frame(height: Theme.spacing.md2)
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

  private func dayHeader(for date: Date) -> some View {
    let title = dayHeaderTitle(for: date)
    let subtitle = dayHeaderSubtitle(for: date)

    return HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.sm) {
      Text(title)
        .font(Theme.font.title4)
        .fontWeight(.bold)
        .foregroundColor(Theme.color.foreground)

      Text(subtitle)
        .font(Theme.font.footnote)
        .foregroundColor(Theme.color.mutedForeground)

      Spacer()
    }
  }

  private func dayHeaderTitle(for date: Date) -> String {
    return Self.monthDayFormatter.string(from: date)
  }

  private func dayHeaderSubtitle(for date: Date) -> String {
    let wd = Self.weekdayFormatter.string(from: date)
    let year = Self.yearFormatter.string(from: date)
    return "\(wd) · \(year)"
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
