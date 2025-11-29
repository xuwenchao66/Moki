//
//  DesignSystemPreview.swift
//  Moki
//
//  设计系统预览页面
//  展示所有设计元素和组件
//

import SwiftUI

struct DesignSystemPreview: View {
  @State private var selectedTab = 2  // 默认展示日记示例

  var body: some View {
    NavigationStack {
      TabView(selection: $selectedTab) {
        // 颜色系统
        ColorSystemView()
          .tabItem {
            Label("颜色", systemImage: "paintpalette")
          }
          .tag(0)

        // 组件库
        ComponentLibraryView()
          .tabItem {
            Label("组件", systemImage: "square.stack.3d.up")
          }
          .tag(1)

        // 日记卡片示例
        JournalCardExamplesView()
          .tabItem {
            Label("Moki", systemImage: "doc.text")
          }
          .tag(2)
      }
      .navigationTitle("Moki 设计系统")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

// MARK: - 颜色系统预览

struct ColorSystemView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Theme.spacing.xl) {
        // 主色调
        ColorSection(title: "主色调 (Primary)") {
          ColorSwatch("背景色", color: Theme.color.background)
          ColorSwatch("卡片背景", color: Theme.color.cardBackground)
          ColorSwatch("主前景色", color: Theme.color.foreground)
        }

        // 动作色
        ColorSection(title: "动作色 (Action)") {
          ColorSwatch("主动作色", color: Theme.color.primaryAction)
          ColorSwatch("前景", color: Theme.color.primaryActionForeground)
        }

        // 强调色
        ColorSection(title: "强调色 (Accent)") {
          ColorSwatch("主强调色", color: Theme.color.accent)
          ColorSwatch("浅色背景", color: Theme.color.accentLightBackground)
          ColorSwatch("深色文字", color: Theme.color.accentDarkText)
        }
      }
      .padding(Theme.spacing.lg)
    }
    .background(Theme.color.background)
  }
}

struct ColorSection<Content: View>: View {
  let title: String
  let content: Content

  init(title: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.spacing.md) {
      Text(title)
        .titleStyle()

      content
    }
  }
}

struct ColorSwatch: View {
  let name: String
  let color: Color

  init(_ name: String, color: Color) {
    self.name = name
    self.color = color
  }

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.spacing.xs) {
      RoundedRectangle(cornerRadius: Theme.radius.sm)
        .fill(color)
        .frame(height: 60)
        .overlay(
          RoundedRectangle(cornerRadius: Theme.radius.sm)
            .stroke(Theme.color.border, lineWidth: 1)
        )

      Text(name)
        .font(Theme.font.caption)
        .foregroundColor(Theme.color.foregroundSecondary)
    }
  }
}

// MARK: - 组件库预览

struct ComponentLibraryView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Theme.spacing.xl) {
        // 按钮
        VStack(alignment: .leading, spacing: Theme.spacing.md) {
          Text("按钮 (Buttons)")
            .titleStyle()

          VStack(spacing: Theme.spacing.sm) {
            AppButton("主按钮", icon: "checkmark.circle.fill", style: .primary) {}
            AppButton("次要按钮", icon: "arrow.right", style: .secondary) {}
            AppButton("文本按钮", icon: "info.circle", style: .text) {}
          }
        }

        Separator()

        // 标签
        VStack(alignment: .leading, spacing: Theme.spacing.md) {
          Text("标签 (Tags)")
            .titleStyle()

          VStack(alignment: .leading, spacing: Theme.spacing.md) {
            Text("默认样式")
              .captionStyle()
            TagFlowLayout(
              tags: ["Naval", "幸福", "成长", "学习"]
            )
          }
        }
      }
      .padding(Theme.spacing.lg)
    }
    .background(Theme.color.background)
  }
}

// MARK: - 日记卡片示例 (使用新组件)

struct JournalCardExamplesView: View {
  var body: some View {
    // 复用 TimelineView 以展示真实效果
    TimelineView()
  }
}

// MARK: - Preview

#Preview("设计系统") {
  configureAppDependencies()
  return DesignSystemPreview()
}
