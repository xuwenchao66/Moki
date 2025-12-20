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

              ForEach(entries) { entry in
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

#Preview {
  TimelineView(isSideMenuPresented: .constant(false))
}
