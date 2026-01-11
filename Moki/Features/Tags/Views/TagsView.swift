import SQLiteData
import SwiftUI

// MARK: - Main View

struct TagsView: View {
  @FetchAll(MokiTag.order { $0.createdAt.desc() })
  private var allTags: [MokiTag]

  private let tagService = TagService()

  var onMenuButtonTapped: (() -> Void)? = nil

  // MARK: - State

  @State private var searchText: String = ""
  @State private var selectedTagIds: Set<UUID> = []

  // MARK: - Computed

  /// 过滤后的标签（基于搜索文本）
  private var filteredTags: [MokiTag] {
    let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard !trimmed.isEmpty else { return allTags }
    return allTags.filter { $0.name.lowercased().contains(trimmed) }
  }

  /// 是否显示创建按钮（输入非空且没有完全匹配）
  private var shouldShowCreateButton: Bool {
    let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return false }
    return !allTags.contains { $0.name.lowercased() == trimmed.lowercased() }
  }

  /// 创建按钮的标签名
  private var createTagName: String {
    searchText.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  // MARK: - Body

  var body: some View {
    VStack(spacing: 0) {
      // 搜索框
      searchBar

      // 标签流式布局
      ScrollView {
        tagFlowLayout
          .padding(.top, Theme.spacing.lg2)
      }

      Spacer()
    }
    .padding(.horizontal, Theme.spacing.md2)
    .background(Theme.color.background)
    .navigationTitle("标签")
    .navigationBarTitleDisplayMode(.inline)
    .alert("重命名标签", isPresented: $isRenameAlertPresented) {
      TextField("标签名称", text: $renameText)
        .textInputAutocapitalization(.never)

      Button("保存") {
        handleRename()
      }
      .disabled(renameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

      Button("取消", role: .cancel) {
        renameTagTarget = nil
        renameText = ""
      }
    }
  }

  // MARK: - Search Bar

  private var searchBar: some View {
    SearchBar(text: $searchText, placeholder: "搜索或创建标签...")
  }

  // MARK: - Tag Flow Layout

  private var tagFlowLayout: some View {
    FlowLayout(spacing: Theme.spacing.xs) {
      // 创建按钮（如果需要）
      if shouldShowCreateButton {
        createTagButton
      }

      // 标签列表
      ForEach(filteredTags) { tag in
        tagChip(for: tag)
      }
    }
  }

  // MARK: - Create Tag Button

  private var createTagButton: some View {
    Button {
      handleCreate(name: createTagName)
    } label: {
      HStack(spacing: Theme.spacing.xxs) {
        Image(systemName: "plus")
          .font(.system(size: 14, weight: .medium))

        Text("创建 \"\(createTagName)\"")
          .font(Theme.font.subheadline)
      }
      .foregroundColor(Theme.color.mutedForeground)
      .padding(.horizontal, Theme.spacing.md)
      .padding(.vertical, Theme.spacing.xs)
      .background(Theme.color.background)
      .clipShape(RoundedRectangle(cornerRadius: Theme.radius.lg, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: Theme.radius.lg, style: .continuous)
          .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
          .foregroundColor(Theme.color.mutedForeground)
      )
    }
    .buttonStyle(.plain)
  }

  // MARK: - Tag Chip

  private func tagChip(for tag: MokiTag) -> some View {
    let isSelected = selectedTagIds.contains(tag.id)

    return TagChip(
      name: tag.name,
      mode: .selectable(isSelected: isSelected),
      onTap: { toggleSelection(for: tag) }
    )
    .contextMenu {
      tagContextMenu(for: tag)
    }
  }

  // MARK: - Context Menu

  @ViewBuilder
  private func tagContextMenu(for tag: MokiTag) -> some View {
    Button {
      showRenameAlert(for: tag)
    } label: {
      Label("重命名", systemImage: "pencil")
    }

    Button(role: .destructive) {
      tagService.delete(tag)
    } label: {
      Label("删除", systemImage: "trash")
    }
  }

  // MARK: - Alert State for Rename

  @State private var isRenameAlertPresented = false
  @State private var renameTagTarget: MokiTag? = nil
  @State private var renameText = ""

  private func showRenameAlert(for tag: MokiTag) {
    renameTagTarget = tag
    renameText = tag.name
    isRenameAlertPresented = true
  }

  // MARK: - Actions

  private func toggleSelection(for tag: MokiTag) {
    HapticManager.shared.light()
    if selectedTagIds.contains(tag.id) {
      selectedTagIds.remove(tag.id)
    } else {
      selectedTagIds.insert(tag.id)
    }
  }

  private func handleCreate(name: String) {
    HapticManager.shared.medium()
    if tagService.create(name: name) {
      searchText = ""
    }
  }

  private func handleRename() {
    guard let tag = renameTagTarget else { return }
    let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }
    _ = tagService.rename(tag, to: trimmed)
    renameTagTarget = nil
    renameText = ""
  }
}

// MARK: - Preview

#Preview {
  configureAppDependencies()
  return NavigationStack {
    TagsView()
  }
}
