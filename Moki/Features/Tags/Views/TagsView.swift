import Dependencies
import SQLiteData
import SwiftUI

struct TagsView: View {
  @FetchAll(MokiTag.order { $0.createdAt.desc() })
  private var tags: [MokiTag]

  @Dependency(\.defaultDatabase) private var database

  var onMenuButtonTapped: (() -> Void)? = nil
  @State private var editorMode: TagEditorMode = .create
  @State private var editorName: String = ""
  @State private var isEditorPresented = false

  var body: some View {
    NavigationStack {
      content
        .navigationTitle("标签")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              onMenuButtonTapped?()
            } label: {
              Image(systemName: "line.3.horizontal")
            }
            .toolbarIconStyle()
          }

          ToolbarItem(placement: .primaryAction) {
            Button {
              showEditor(.create)
            } label: {
              Image(systemName: "plus")
            }
            .toolbarIconStyle()
          }
        }
    }
    .alert(editorTitle, isPresented: $isEditorPresented) {
      TextField("例如：灵感、阅读、健身...", text: $editorName)
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)

      Button(editorActionTitle) {
        commit()
      }
      .disabled(isEditorNameInvalid)

      Button("取消", role: .cancel) {
        isEditorPresented = false
      }
    }
  }

  @ViewBuilder
  private var content: some View {
    if tags.isEmpty {
      EmptyStateView(
        title: "暂无标签",
        message: "点击右上角的 + 创建第一个标签"
      ) {
        showEditor(.create)
      }
      .background(Theme.color.background)
    } else {
      List {
        Section {
          ForEach(tags) { tag in
            HStack {
              Text("#\(tag.name)")
                .font(Theme.font.body)
                .foregroundColor(Theme.color.foreground)

              Spacer()

              Menu {
                tagMenu(for: tag)
              } label: {
                Image(systemName: "ellipsis")
                  .font(.system(size: 16))
                  .foregroundColor(Theme.color.foregroundTertiary)
                  .frame(width: 38, height: 38, alignment: .trailing)
                  .contentShape(Rectangle())
              }
              .buttonStyle(.plain)  // 避免点击整行触发 Menu
            }
            .contextMenu {
              tagMenu(for: tag)
            }
          }
        }
      }
      .listStyle(.insetGrouped)
      .scrollContentBackground(.hidden)
      .background(Theme.color.background)
    }
  }

  // MARK: - Actions

  private func handleCreate(name: String) -> Bool {
    do {
      try insertTag(named: name)
      AppToast.show("已创建标签「\(name)」")
      return true
    } catch {
      AppToast.show(errorMessage(for: error))
      return false
    }
  }

  private func handleRename(tag: MokiTag, newName: String) -> Bool {
    do {
      try rename(tag: tag, to: newName)
      AppToast.show("已重命名为「\(newName)」")
      return true
    } catch {
      AppToast.show(errorMessage(for: error))
      return false
    }
  }

  private func delete(tag: MokiTag) {
    do {
      try database.write { db in
        try MokiTag
          .delete(tag)
          .execute(db)
      }
      AppToast.show("已删除标签「\(tag.name)」")
    } catch {
      AppToast.show(errorMessage(for: error))
    }
  }

  private func insertTag(named name: String) throws {
    let sanitized = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard sanitized.isEmpty == false else { return }

    let tag = MokiTag(name: sanitized)
    try database.write { db in
      try MokiTag.insert { tag }
        .execute(db)
    }
  }

  private func rename(tag: MokiTag, to newName: String) throws {
    let sanitized = newName.trimmingCharacters(in: .whitespacesAndNewlines)
    guard sanitized.isEmpty == false else { return }

    try database.write { db in
      try MokiTag
        .update { $0.name = sanitized }
        .where { $0.id.eq(tag.id) }
        .execute(db)
    }
  }

  private func errorMessage(for error: Error) -> String {
    let message = error.localizedDescription
    if message.contains("UNIQUE") {
      return "标签名称已存在，换一个试试。"
    }
    return "发生错误：\(message)"
  }

  @ViewBuilder
  private func tagMenu(for tag: MokiTag) -> some View {
    Button {
      showEditor(.edit(tag))
    } label: {
      Label("重命名", systemImage: "pencil")
    }

    Button(role: .destructive) {
      delete(tag: tag)
    } label: {
      Label("删除", systemImage: "trash")
    }
  }

  private func showEditor(_ mode: TagEditorMode) {
    editorMode = mode
    editorName = mode.initialName
    isEditorPresented = true
  }

  private func commit() {
    let mode = editorMode
    let trimmed = trimmedEditorName
    guard isEditorNameInvalid == false else { return }

    let isSuccess: Bool
    switch mode {
    case .create:
      isSuccess = handleCreate(name: trimmed)
    case let .edit(tag):
      isSuccess = handleRename(tag: tag, newName: trimmed)
    }

    if isSuccess {
      isEditorPresented = false
      editorName = ""
    }
  }

  private var editorTitle: String {
    switch editorMode {
    case .create:
      return "新建标签"
    case .edit:
      return "编辑标签"
    }
  }

  private var editorActionTitle: String {
    switch editorMode {
    case .create:
      return "创建"
    case .edit:
      return "保存"
    }
  }

  /// 去掉前后空白后的输入内容
  private var trimmedEditorName: String {
    editorName.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  /// 当前输入是否无效（为空）
  private var isEditorNameInvalid: Bool {
    trimmedEditorName.isEmpty
  }
}

// MARK: - Editor Helpers

private enum TagEditorMode {
  case create
  case edit(MokiTag)

  var initialName: String {
    switch self {
    case .create:
      return ""
    case let .edit(tag):
      return tag.name
    }
  }
}

#Preview {
  configureAppDependencies()
  return TagsView()
}
