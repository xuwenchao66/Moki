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

  private static let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  // 用于显示的日期格式
  private static let headerDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  // 按日期分组的数据 (Flat List of Days)
  private var groupedEntries: [(date: Date, entries: [MokiDiary])] {
    // 1. 按日期分组
    let byDay = Dictionary(grouping: entries) { entry -> String in
      return Self.dayFormatter.string(from: entry.createdAt)
    }

    // 2. 日期倒序排序
    return byDay.keys.sorted(by: >).map { dayKey -> (date: Date, entries: [MokiDiary]) in
      let dayEntries = byDay[dayKey]!.sorted { $0.createdAt > $1.createdAt }
      // 使用该组第一条的时间作为 Key
      return (date: dayEntries.first?.createdAt ?? Date(), entries: dayEntries)
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
            action: { showAddEntry = true }
          )
        } else {
          ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
              // 顶部留白
              Color.clear.frame(height: Theme.spacing.md)

              ForEach(groupedEntries, id: \.date) { dayGroup in
                Section(header: DayHeaderView(date: dayGroup.date)) {
                  VStack(spacing: 0) {
                    ForEach(dayGroup.entries) { entry in
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
                      
                      // 移除之前的 Divider，使用透明留白
                      if entry.id != dayGroup.entries.last?.id {
                           Color.clear.frame(height: Theme.spacing.md)
                      }
                    }
                  }
                  .padding(.bottom, Theme.spacing.xl)  // 不同日期组之间的大间距
                }
              }

              Spacer(minLength: 80)
            }
          }
          .background(Theme.color.background)
        }

        // FAB
        Button(action: { showAddEntry = true }) {
          Image(systemName: "plus")
            .font(.system(size: 24, weight: .light))
            .foregroundColor(.white)  // 纯白图标
            .frame(width: 56, height: 56)
            .background(Color(white: 0.2))  // 深灰黑色背景，更高级
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
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

/// 日期 Sticky Header (极简风格)
struct DayHeaderView: View {
  let date: Date

  var body: some View {
    HStack {
      // 纯文本展示，去除胶囊背景
      // 强调“日”，弱化“年月”
      HStack(alignment: .firstTextBaseline, spacing: 4) {
          Text(dayString)
            .font(.system(size: 20, weight: .bold, design: .default))
            .foregroundColor(Theme.color.foreground) // 主色黑

          Text(monthString)
            .font(.system(size: 14, weight: .regular, design: .default))
            .foregroundColor(Theme.color.foregroundSecondary) // 次级灰
      }
      
      Spacer()
    }
    .padding(.horizontal, Theme.spacing.md)
    .padding(.top, Theme.spacing.lg) // 稍微拉开与上一条的距离
    .padding(.bottom, Theme.spacing.xs) // 紧贴下方第一条内容
    .background(Theme.color.background.opacity(0.98)) // 半透明背景
  }

  private var dayString: String {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd"
      return formatter.string(from: date)
  }
    
  // 中文年月格式：11月 2025
  private var monthString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M月 yyyy"
    formatter.locale = Locale(identifier: "zh_CN")
    return formatter.string(from: date)
  }
}

#Preview {
  TimelineView(isSideMenuPresented: .constant(false))
}
