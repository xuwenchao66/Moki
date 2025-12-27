import SQLiteData
import SwiftUI

struct TagsView: View {
  @FetchAll(MokiTag.order { $0.createdAt.desc() })
  private var tags: [MokiTag]

  private let tagService = TagService()

  var onMenuButtonTapped: (() -> Void)? = nil
  @State private var editorMode: TagEditorMode = .create
  @State private var editorName: String = ""
  @State private var isEditorPresented = false

  var body: some View {
    content
      .navigationTitle("标签")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button {
            showEditor(.create)
          } label: {
            Image(systemName: "plus")
          }
        }
      }
      .alert(editorTitle, isPresented: $isEditorPresented) {
        TextField("", text: $editorName)
          .textInputAutocapitalization(.never)

        Button(editorActionTitle) {
          commit()
        }
        .disabled(isEditorNameInvalid)

        Button("取消", role: .cancel) {
          isEditorPresented = false
        }
      } message: {
        Text("例如：灵感、阅读、健身...")
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
                  .foregroundColor(Theme.color.mutedForeground)
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

  private func handleCreate(name: String) {
    if tagService.create(name: name) {
      isEditorPresented = false
      editorName = ""
    }
  }

  private func handleRename(tag: MokiTag, newName: String) {
    if tagService.rename(tag, to: newName) {
      isEditorPresented = false
      editorName = ""
    }
  }

  private func delete(tag: MokiTag) {
    tagService.delete(tag)
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

    switch mode {
    case .create:
      handleCreate(name: trimmed)
    case let .edit(tag):
      handleRename(tag: tag, newName: trimmed)
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
  return NavigationStack {
    TagsView()
  }
}
