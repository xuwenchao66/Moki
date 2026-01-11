import SwiftUI

// MARK: - Tag Display Mode

/// 标签显示模式
/// 根据设计规范，标签在不同场景下有不同的视觉表现
enum TagDisplayMode {
  /// 阅读模式 - 用于 Timeline
  /// 纯文字，无背景，极度弱化，不抢正文的戏
  case read

  /// 交互模式 - 用于编辑器底部
  /// 有实体感，浅色背景，像积木一样可操作
  case interactive

  /// 选择模式 - 用于标签管理器
  /// 支持选中/未选中状态切换
  case selectable(isSelected: Bool)
}

// MARK: - Tag Chip Component

/// 通用标签组件
/// 根据不同场景自动应用对应的视觉样式
struct TagChip: View {
  let name: String
  let mode: TagDisplayMode
  var onTap: (() -> Void)? = nil
  var onRemove: (() -> Void)? = nil

  var body: some View {
    Group {
      switch mode {
      case .read:
        readModeView
      case .interactive:
        interactiveModeView
      case .selectable(let isSelected):
        selectableModeView(isSelected: isSelected)
      }
    }
  }

  // MARK: - Read Mode (Timeline)

  /// 阅读模式：纯文字，无背景，极简
  private var readModeView: some View {
    Text(tagText())
      .font(Theme.font.footnote)
      .foregroundColor(Theme.color.mutedForeground)
  }

  // MARK: - Chip Shape

  /// 标签圆角 - 固定圆角矩形，不是胶囊
  private var chipShape: RoundedRectangle {
    RoundedRectangle(cornerRadius: Theme.radius.md, style: .continuous)
  }

  // MARK: - Interactive Mode (Editor Bottom)

  /// 交互模式：有实体感，可移除
  private var interactiveModeView: some View {
    HStack(spacing: Theme.spacing.xxs) {
      Text(tagText())
        .font(Theme.font.subheadline)
        .foregroundColor(Theme.color.secondaryForeground)

      // 移除按钮（如果提供了 onRemove）
      if let onRemove {
        Button(action: onRemove) {
          Image(systemName: "xmark")
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(Theme.color.mutedForeground)
        }
        .buttonStyle(.plain)
      }
    }
    .padding(.horizontal, Theme.spacing.sm)
    .padding(.vertical, Theme.spacing.xs)
    .background(Theme.color.muted)
    .clipShape(chipShape)
    .contentShape(chipShape)
    .onTapGesture {
      onTap?()
    }
  }

  // MARK: - Selectable Mode (Tag Manager)

  /// 选择模式：支持选中/未选中状态
  private func selectableModeView(isSelected: Bool) -> some View {
    Text(tagText())
      .font(Theme.font.subheadline)
      .foregroundColor(isSelected ? Theme.color.primaryForeground : Theme.color.foreground)
      .padding(.horizontal, Theme.spacing.md)
      .padding(.vertical, Theme.spacing.xs)
      .background(isSelected ? Theme.color.foreground : Theme.color.background)
      .clipShape(chipShape)
      .overlay(
        chipShape
          .stroke(Theme.color.border, lineWidth: 1)
      )
      .contentShape(chipShape)
      .onTapGesture {
        onTap?()
      }
  }

  // MARK: - Helper

  /// 统一的标签文本：在名称前拼接 #
  private func tagText() -> String {
    "#\(name)"
  }
}

// MARK: - Preview

#Preview("Read Mode - Timeline") {
  VStack(alignment: .leading, spacing: Theme.spacing.md) {
    Text("1. HOME TIMELINE (READ MODE)")
      .font(.caption)
      .foregroundColor(.secondary)

    HStack(spacing: Theme.spacing.sm) {
      Text("16:42")
        .font(Theme.font.footnote)
        .foregroundColor(Theme.color.mutedForeground)

      TagChip(name: "Photography", mode: .read)
      TagChip(name: "Life", mode: .read)
    }
  }
  .padding()
  .background(Theme.color.background)
}

#Preview("Interactive Mode - Editor") {
  VStack(alignment: .leading, spacing: Theme.spacing.md) {
    Text("2. EDITOR BOTTOM (INTERACTIVE MODE)")
      .font(.caption)
      .foregroundColor(.secondary)

    HStack(spacing: Theme.spacing.xs) {
      TagChip(name: "Life", mode: .interactive, onRemove: {})
      TagChip(name: "Thoughts", mode: .interactive, onRemove: {})
    }
    .padding()
    .background(Theme.color.card)
    .clipShape(RoundedRectangle(cornerRadius: Theme.radius.lg))
  }
  .padding()
  .background(Theme.color.background)
}

#Preview("Selectable Mode - Tag Manager") {
  VStack(alignment: .leading, spacing: Theme.spacing.md) {
    Text("3. TAG MANAGER (SELECTION MODE)")
      .font(.caption)
      .foregroundColor(.secondary)

    FlowLayout(spacing: Theme.spacing.xs) {
      TagChip(name: "Work", mode: .selectable(isSelected: false))
      TagChip(name: "Design", mode: .selectable(isSelected: true))
      TagChip(name: "Travel", mode: .selectable(isSelected: false))
      TagChip(name: "Food", mode: .selectable(isSelected: false))
      TagChip(name: "Moki App", mode: .selectable(isSelected: false))
    }
  }
  .padding()
  .background(Theme.color.background)
}
