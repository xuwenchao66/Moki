import SQLiteData
import SwiftUI

struct TimelineView: View {
  @Binding var isSideMenuPresented: Bool

  // MARK: - Data

  @State private var showAddEntry = false

  // 从数据库自动拉取所有日记，并按创建时间倒序排列
  @FetchAll(MokiDiary.order { $0.createdAt.desc() })
  private var entries: [MokiDiary]

  // 仅展示今天的日记
  var todaysEntries: [MokiDiary] {
    let calendar = Calendar.current
    return entries.filter { calendar.isDateInToday($0.createdAt) }
  }

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
    func time(_ hour: Int, _ minute: Int) -> Date {
      return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now
    }

    return [
      MockEntry(
        content: "欲望是你跟自己签的协议：在得到你想要的东西之前，你一直不会快乐。",
        date: time(23, 42),
        images: [],
        tags: ["Naval", "智慧"]
      ),
      MockEntry(
        content: "下班路上的光影，治愈了一整天的疲惫。",
        date: time(20, 15),
        images: ["1"],
        tags: ["摄影"]
      ),
      MockEntry(
        content: "趁着午休时间去公园走了走，秋天真的太美了。\n\n阳光透过树叶洒下来，像是给地面铺了一层金箔。空气里有桂花的香味，深呼吸，感觉肺都被净化了。",
        date: time(12, 30),
        images: ["1", "2"],
        tags: []
      ),
      MockEntry(
        content: "早安 Moki。新的一天，保持专注。",
        date: time(08, 00),
        images: [],
        tags: ["早安"]
      ),
    ]
  }

  // MARK: - View

  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      VStack(spacing: 0) {
        // 1. 自定义顶部导航栏
        HStack {
          Button(action: {
            withAnimation {
              isSideMenuPresented.toggle()
            }
          }) {
            Image(systemName: "line.3.horizontal")
              .font(.system(size: 18, weight: .regular))  // 恢复常规字重
              .foregroundColor(Theme.color.foregroundSecondary)
          }

          Spacer()

          Text(formattedDate(Date()))
            .font(Theme.font.dateTitle)  // 保持 Serif
            .fontWeight(.medium)
            .foregroundColor(Theme.color.foreground)

          Spacer()

          Button(action: {}) {
            Image(systemName: "magnifyingglass")
              .font(.system(size: 18, weight: .regular))  // 恢复常规字重
              .foregroundColor(Theme.color.foregroundSecondary)
          }
        }
        .padding(.horizontal, Theme.spacing.lg)
        .padding(.top, Theme.spacing.md)
        .padding(.bottom, Theme.spacing.md)
        .background(Theme.color.background)

        // 2. 滚动内容区
        ScrollView {
          // 暂时强制使用 mockEntries 进行预览
          // if todaysEntries.isEmpty {
          if false {
            // 空状态
            VStack(spacing: Theme.spacing.lg) {
              Spacer(minLength: 100)
              Image(systemName: "square.and.pencil")
                .font(.system(size: 48))
                .foregroundColor(Theme.color.foregroundTertiary)
              Text("记录当下的想法...")
                .font(Theme.font.body)
                .foregroundColor(Theme.color.foregroundSecondary)
            }
          } else {
            LazyVStack(spacing: 0) {
              // 使用 mockEntries 替代 todaysEntries
              ForEach(mockEntries) { entry in
                JournalItemView(
                  content: entry.content,
                  time: formatTime(entry.date),
                  tags: entry.tags,
                  images: entry.images
                )
              }

              Spacer(minLength: 100)  // 底部留白
            }
            .padding(.horizontal, Theme.spacing.lg)
            .padding(.top, Theme.spacing.md)
          }
        }
      }
      .background(Theme.color.background)

      // 3. 悬浮按钮 (FAB)
      Button(action: {
        showAddEntry = true
      }) {
        Image(systemName: "plus")
          .font(.system(size: 24, weight: .medium))
          .foregroundColor(.white)
          .frame(width: 56, height: 56)
          .background(Theme.color.primaryAction)
          .clipShape(Circle())
          .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
      }
      .padding(.trailing, Theme.spacing.lg)
      .padding(.bottom, Theme.spacing.lg)
    }
    .sheet(isPresented: $showAddEntry) {
      NavigationStack {
        EditView()
      }
    }
  }

  // MARK: - Helpers

  private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"  // 23:42
    return formatter.string(from: date)
  }

  private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "M月d日"
    return formatter.string(from: date)
  }
}

#Preview {
  // configureAppDependencies() // Preview might not have this
  return TimelineView(isSideMenuPresented: .constant(false))
}
