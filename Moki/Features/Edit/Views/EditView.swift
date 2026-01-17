import SQLiteData
import SwiftUI

struct EditView: View {
  @Environment(\.dismiss) private var dismiss

  @State private var content: String = ""
  @State private var isFocused: Bool = false
  @State private var showTagsSheet = false
  @State private var selectedTagIds: Set<UUID> = []

  @FetchAll(MokiTag.order { $0.createdAt.desc() })
  private var allTags: [MokiTag]

  private var selectedTags: [MokiTag] {
    allTags.filter { selectedTagIds.contains($0.id) }
  }

  private let diaryService = DiaryService()

  // 保持当前时间用于显示
  private let entryDate = Date()

  var body: some View {
    VStack(spacing: 0) {
      // 1. Header
      headerView
        .padding(.vertical, Theme.spacing.md)
        .padding(.horizontal, Theme.spacing.lg)

      // 2. Editor
      PlainTextEditor(
        text: $content,
        isFocused: $isFocused,
        placeholder: "记录此刻..."
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding(.horizontal, Theme.spacing.lg)

      // 3. Toolbar
      toolbarView
    }
    .background(Theme.color.background)
    .toolbar(.hidden, for: .navigationBar)
    .sheet(isPresented: $showTagsSheet) {
      NavigationStack {
        TagsView(selection: $selectedTagIds)
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button("完成") {
                showTagsSheet = false
              }
            }
          }
      }
      .presentationDetents([.medium, .large])
    }
    .onAppear {
      isFocused = true
    }
  }

  // MARK: - Subviews

  private var headerView: some View {
    HStack(spacing: Theme.spacing.compact) {
      // 2025.12.28 · 周日 16:54
      Text(formattedDateMain())
      Text("·")
      Text(formattedDateSub())
      Text(formattedTime())

      Spacer()
    }
    .font(Theme.font.callout)
    .foregroundColor(Theme.color.mutedForeground)
  }

  private var toolbarView: some View {
    VStack(spacing: 0) {
      if !selectedTags.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: Theme.spacing.xs) {
            ForEach(selectedTags) { tag in
              TagChip(
                name: tag.name,
                mode: .interactive,
                onRemove: {
                  HapticManager.shared.light()
                  selectedTagIds.remove(tag.id)
                }
              )
            }
          }
          .padding(.horizontal, Theme.spacing.lg)
          .padding(.bottom, Theme.spacing.sm)
        }
      }

      Divider()
        .overlay(Theme.color.border)

      HStack {
        // 左侧功能区
        HStack(spacing: Theme.spacing.lg) {
          Button(action: {
            HapticManager.shared.light()
            showTagsSheet = true
          }) {
            AppIcon(icon: .hash, size: .md, color: Theme.color.secondaryForeground)
              .contentShape(Rectangle())
          }

          Button(action: {
            HapticManager.shared.light()
            /* TODO: Photo */
          }) {
            AppIcon(icon: .image, size: .md, color: Theme.color.secondaryForeground)
              .contentShape(Rectangle())
          }

          Button(action: {
            HapticManager.shared.light()
            /* TODO: Camera */
          }) {
            AppIcon(icon: .camera, size: .md, color: Theme.color.secondaryForeground)
              .contentShape(Rectangle())
          }
        }

        Spacer()

        // 右侧保存按钮
        Button(action: {
          HapticManager.shared.light()
          saveEntry()
        }) {
          ZStack {
            Capsule()
              .fill(Theme.color.buttonBackground)
              .frame(width: 56, height: 36)
              .appShadow(Theme.shadow.sm)

            AppIcon(icon: .check, size: .sm, color: Theme.color.primaryForeground)
          }
        }
        .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        .opacity(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1)
      }
      .padding(.horizontal, Theme.spacing.lg)
      .padding(.vertical, Theme.spacing.sm)
      .background(Theme.color.background)
    }
  }

  // MARK: - Actions

  private func saveEntry() {
    let entry = MokiDiary(
      id: UUID(),
      text: content,
      createdAt: entryDate,
      timeZone: TimeZone.current.identifier
    )
    diaryService.create(entry, tags: selectedTags)
    dismiss()
  }

  // MARK: - Formatters

  private func formattedDateMain() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "yyyy年MM月dd日"
    return formatter.string(from: entryDate)
  }

  private func formattedDateSub() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "EEE"
    return formatter.string(from: entryDate)
  }

  private func formattedTime() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "zh_CN")
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: entryDate)
  }
}

#Preview {
  EditView()
}
