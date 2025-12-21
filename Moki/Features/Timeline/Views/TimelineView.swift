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
            LazyVStack(spacing: 0) {
              // 顶部留白
              Color.clear.frame(height: Theme.spacing.md)

              ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                let showDate = shouldShowDate(at: index)
                let extra = parseMetadata(entry.metadata)

                VStack(spacing: 0) {
                  if showDate {
                    dateHeader(for: entry.createdAt)
                      .padding(.bottom, Theme.spacing.sm)
                      .padding(.top, index == 0 ? 0 : Theme.spacing.md)
                  }

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
                  // 移除之前的 padding，由 JournalItemView 自己控制或这里控制
                  // 如果没有背景卡片，就不需要额外的 padding，除非是 item 间距
                  .padding(.bottom, Theme.spacing.md)
                }
                .padding(.horizontal, Theme.spacing.md)
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

  private func shouldShowDate(at index: Int) -> Bool {
    if index == 0 { return true }
    let current = entries[index].createdAt
    let previous = entries[index - 1].createdAt
    return !Calendar.current.isDate(current, inSameDayAs: previous)
  }

  private func dateHeader(for date: Date) -> some View {
    HStack(spacing: Theme.spacing.xs) {
      Text(date, formatter: Self.capsuleDateFormatter)
        .font(Theme.font.caption)
        .fontWeight(.semibold)
        .foregroundColor(Theme.color.primary)
        .padding(.horizontal, Theme.spacing.xs)
        .padding(.vertical, Theme.spacing.xxs)
        .background(Theme.color.primary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: Theme.radius.lg, style: .continuous))

      Rectangle()
        .fill(Theme.color.border)
        .frame(height: 1)
    }
  }

  private static let capsuleDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "M月d日 yyyy"
    return formatter
  }()

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
