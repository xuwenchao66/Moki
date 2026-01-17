import Dependencies
import SQLiteData
import SwiftUI

struct TimelineView: View {
  @Binding var isSideMenuPresented: Bool
  @State private var isViewActive = false
  @State private var showAddEntry = false
  private let diaryService = DiaryService()

  // 1. 日记数据（响应式）
  @FetchAll(
    MokiDiary
      .where { $0.deletedAt == nil }
      .order { $0.createdAt.desc() }
  )
  private var dbEntries: [MokiDiary]

  // 2. 标签关联数据（响应式）
  @FetchAll(MokiDiaryTag.order { $0.order.asc() })
  private var diaryTags: [MokiDiaryTag]

  // 3. 所有标签（响应式）
  @FetchAll(MokiTag.order { $0.order.asc() })
  private var allTags: [MokiTag]

  // 4. 组装后的数据（自动响应上面三个数据源的变化）
  private var entries: [DiaryWithTags] {
    // 构建 tagId -> MokiTag 映射
    let tagMap = Dictionary(uniqueKeysWithValues: allTags.map { ($0.id, $0) })

    // 构建 diaryId -> [MokiTag] 映射
    var diaryTagsMap: [UUID: [MokiTag]] = [:]
    for relation in diaryTags {
      if let tag = tagMap[relation.tagId] {
        diaryTagsMap[relation.diaryId, default: []].append(tag)
      }
    }

    // 组装结果
    return dbEntries.map { diary in
      DiaryWithTags(
        diary: diary,
        tags: diaryTagsMap[diary.id] ?? []
      )
    }
  }

  // MARK: - Formatters

  private static let weekdayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "EEE"  // 周日/周一…
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
              ForEach(group.entries, id: \.id) { item in
                let images = parseMetadataImages(item.diary.metadata)
                let tagNames = item.tags.map { $0.name }

                JournalItemView(
                  content: item.diary.text,
                  date: item.diary.createdAt,
                  tags: tagNames,
                  images: images,
                  onEditTapped: {
                    // TODO: Edit Action
                  },
                  onDeleteTapped: {
                    diaryService.delete(item.diary)
                  }
                )
                .padding(.bottom, Theme.spacing.md)
              }

              // 天与天之间的大留白
              Color.clear
                .frame(height: Theme.spacing.xxl)
            }
          }
        }
        .padding(.bottom, Theme.spacing.lg)
        .background(Theme.color.background)
        .ignoresSafeArea(edges: .bottom)
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
    let entries: [DiaryWithTags]
  }

  private var dayGroups: [DayGroup] {
    guard !entries.isEmpty else { return [] }

    // 简洁、好维护：直接按"当天 00:00"分组，再按日期倒序输出
    let grouped = Dictionary(grouping: entries) { entry in
      Calendar.current.startOfDay(for: entry.diary.createdAt)
    }

    return grouped.keys
      .sorted(by: >)
      .map { day in
        let list = (grouped[day] ?? []).sorted { $0.diary.createdAt > $1.diary.createdAt }
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
        let weekdayString: String = {
          if Calendar.current.isDateInToday(date) {
            return "今天"
          } else if Calendar.current.isDateInYesterday(date) {
            return "昨天"
          } else {
            return weekday
          }
        }()

        Text("\(month)月 / \(weekdayString)")
        if isPastYear {
          Text(" · \(String(year))")
            .foregroundColor(Theme.color.mutedForeground.opacity(0.8))
        }
      }
      .font(Theme.font.footnote)
      .foregroundColor(Theme.color.mutedForeground)
      .offset(y: -2)

      Spacer()
    }
  }

  private func parseMetadataImages(_ json: String) -> [String] {
    guard let data = json.data(using: .utf8),
      let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else {
      return []
    }
    return dict["images"] as? [String] ?? []
  }
}

#Preview {
  NavigationStack {
    TimelineView(isSideMenuPresented: .constant(false))
  }
}
