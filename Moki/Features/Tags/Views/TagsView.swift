import Dependencies
import SQLiteData
import SwiftUI

struct TagsView: View {
  @FetchAll(MokiTag.order { $0.createdAt.desc() })
  private var tags: [MokiTag]

  @Dependency(\.defaultDatabase) private var database

  var onMenuButtonTapped: (() -> Void)? = nil

  @State private var isPresentingAddSheet = false
  @State private var editingTag: MokiTag?
  @State private var alert: AlertContext?

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
            .accessibilityLabel("打开侧边栏")
          }

          ToolbarItem(placement: .primaryAction) {
            Button {
              isPresentingAddSheet = true
            } label: {
              Image(systemName: "plus")
            }
            .toolbarIconStyle()
            .accessibilityLabel("新增标签")
          }
        }
    }
    .sheet(isPresented: $isPresentingAddSheet) {
      TagEditorSheet(mode: .create) { newName in
        handleCreate(name: newName)
      }
    }
    .sheet(item: $editingTag) { tag in
      TagEditorSheet(mode: .edit(tag)) { newName in
        handleRename(tag: tag, newName: newName)
      }
    }
    .alert(item: $alert) { info in
      Alert(
        title: Text(info.title),
        message: Text(info.message),
        dismissButton: .default(Text("好的"))
      )
    }
  }

  @ViewBuilder
  private var content: some View {
    if tags.isEmpty {
      EmptyStateView(
        title: "暂无标签",
        message: "点击右上角的 + 创建第一个标签"
      ) {
        isPresentingAddSheet = true
      }
      .background(Theme.color.background)
    } else {
      List {
        Section(
          footer: Text("共 \(tags.count) 个标签")
            .font(Theme.font.caption)
            .foregroundColor(Theme.color.foregroundTertiary)
        ) {
          ForEach(tags) { tag in
            TagRow(tag: tag)
              .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button {
                  editingTag = tag
                } label: {
                  Label("重命名", systemImage: "pencil")
                }
                .tint(Theme.color.accent)

                Button(role: .destructive) {
                  delete(tag: tag)
                } label: {
                  Label("删除", systemImage: "trash")
                }
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
      return true
    } catch {
      alert = .error(title: "创建失败", message: errorMessage(for: error))
      return false
    }
  }

  private func handleRename(tag: MokiTag, newName: String) -> Bool {
    do {
      try rename(tag: tag, to: newName)
      return true
    } catch {
      alert = .error(title: "重命名失败", message: errorMessage(for: error))
      return false
    }
  }

  private func delete(tag: MokiTag) {
    do {
      try database.write { db in
        try #sql(
          """
          DELETE FROM "tags"
          WHERE "id" = \(tag.id.uuidString)
          """
        )
        .execute(db)
      }
    } catch {
      alert = .error(title: "删除失败", message: errorMessage(for: error))
    }
  }

  private func insertTag(named name: String) throws {
    let sanitized = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard sanitized.isEmpty == false else { return }

    let tag = MokiTag(name: sanitized)
    try database.write { db in
      try #sql(
        """
        INSERT INTO "tags" ("id", "name", "color", "createdAt")
        VALUES (
          \(tag.id.uuidString),
          \(tag.name),
          \(tag.color),
          \(tag.createdAt)
        )
        """
      )
      .execute(db)
    }
  }

  private func rename(tag: MokiTag, to newName: String) throws {
    let sanitized = newName.trimmingCharacters(in: .whitespacesAndNewlines)
    guard sanitized.isEmpty == false else { return }

    try database.write { db in
      try #sql(
        """
        UPDATE "tags"
        SET "name" = \(sanitized)
        WHERE "id" = \(tag.id.uuidString)
        """
      )
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
}

// MARK: - Helpers

private struct TagRow: View {
  let tag: MokiTag

  var body: some View {
    HStack(spacing: Theme.spacing.sm) {
      Text("#\(tag.name)")
        .font(Theme.font.body)
        .foregroundColor(Theme.color.foreground)

      Spacer()

      Image(systemName: "chevron.right")
        .font(.system(size: 13, weight: .semibold))
        .foregroundColor(Theme.color.foregroundTertiary)
    }
    .padding(.vertical, Theme.spacing.xs)
  }
}

private struct AlertContext: Identifiable {
  let id = UUID()
  let title: String
  let message: String

  static func error(title: String, message: String) -> AlertContext {
    AlertContext(title: title, message: message)
  }
}

// MARK: - Editor Sheet

private struct TagEditorSheet: View {
  enum Mode {
    case create
    case edit(MokiTag)

    var title: String {
      switch self {
      case .create:
        return "新建标签"
      case .edit:
        return "编辑标签"
      }
    }

    var actionTitle: String {
      switch self {
      case .create:
        return "创建"
      case .edit:
        return "保存"
      }
    }

    var initialName: String {
      switch self {
      case .create:
        return ""
      case let .edit(tag):
        return tag.name
      }
    }
  }

  @Environment(\.dismiss) private var dismiss

  let mode: Mode
  let onSubmit: (String) -> Bool

  @State private var name: String
  @FocusState private var isFocused: Bool

  init(mode: Mode, onSubmit: @escaping (String) -> Bool) {
    self.mode = mode
    self.onSubmit = onSubmit
    _name = State(initialValue: mode.initialName)
  }

  var body: some View {
    NavigationStack {
      Form {
        Section(header: Text("名称")) {
          TextField("例如：灵感、阅读、健身...", text: $name)
            .focused($isFocused)
            .submitLabel(.done)
        }
      }
      .navigationTitle(mode.title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("取消") {
            dismiss()
          }
        }

        ToolbarItem(placement: .confirmationAction) {
          Button(mode.actionTitle) {
            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.isEmpty == false else { return }
            if onSubmit(trimmed) {
              dismiss()
            }
          }
          .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
      }
      .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          isFocused = true
        }
      }
    }
  }
}

#Preview {
  configureAppDependencies()
  return TagsView()
}
