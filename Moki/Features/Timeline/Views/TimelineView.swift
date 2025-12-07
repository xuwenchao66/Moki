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
  // MockEntry is now defined in Moki/Features/Timeline/Models/MockTimelineData.swift

  // 硬编码的演示数据
  private var mockEntries: [MockEntry] {
    return MockEntry.examples
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
          LazyVStack(spacing: 0) {
            ForEach(groupedEntries, id: \.month) { group in
              monthHeader(group.month)

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

            Spacer(minLength: 40)  // 底部留白
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

  // MARK: - Helpers

  private func monthHeader(_ month: String) -> some View {
    HStack {
      Text(month)
        .font(Theme.font.title2)
        .foregroundColor(Theme.color.foreground)
        .padding(.horizontal, Theme.spacing.md2)
        .padding(.vertical, Theme.spacing.sm)
      Spacer()
    }
    .background(Theme.color.background)
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
