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

// MARK: - 日记卡片示例 (高度还原)

struct JournalCardExamplesView: View {
  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      ScrollView {
        VStack(spacing: 0) {  // 移除默认间距，完全控制布局

          // 顶部日期组 - 2025-11-23
          JournalDateHeader(date: "2025-11-23")
            .padding(.top, Theme.spacing.lg)

          // 日记条目 1
          JournalItemView(
            content: "欲望是你跟自己签的协议：在得到你想要的东西之前，你一直不会快乐。",
            time: "23:42:15",
            tags: ["Naval", "幸福"]
          )

          // 顶部日期组 - 2025-11-22
          JournalDateHeader(date: "2025-11-22")
            .padding(.top, Theme.spacing.xl)

          // 日记条目 2 (带图)
          JournalItemView(
            content: "对行动要有急迫感，对结果要有耐心。",
            time: "15:20:08",
            tags: ["Naval", "智慧"],
            images: ["photo1", "photo2"]  // 模拟图片
          )

          // 日记条目 3
          JournalItemView(
            content: "幸福是一种技能，就像健身和赚钱一样。",
            time: "11:05:33",
            tags: ["Naval", "成长"]
          )

          // 顶部日期组 - 2025-11-21
          JournalDateHeader(date: "2025-11-21")
            .padding(.top, Theme.spacing.xl)

          // 日记条目 4
          JournalItemView(
            content: "阅读比听更有效率。做比看更有效率。",
            time: "19:15:42",
            tags: ["Naval", "学习"]
          )

          Spacer(minLength: 100)  // 底部留白
        }
        .padding(.horizontal, Theme.spacing.lg)
      }
      .background(Theme.color.background)

      // 悬浮按钮 FAB
      Button(action: {}) {
        Image(systemName: "plus")
          .font(.system(size: 24, weight: .medium))
          .foregroundColor(.white)
          .frame(width: 56, height: 56)
          .background(Theme.color.primaryAction)  // 黑色背景
          .clipShape(Circle())
          .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
      }
      .padding(.trailing, Theme.spacing.lg)
      .padding(.bottom, Theme.spacing.lg)
    }
  }
}

// MARK: - Helper Views for Journal

struct JournalDateHeader: View {
  let date: String

  var body: some View {
    HStack {
      Text(date)
        .font(Theme.font.tag.weight(.semibold))
        .foregroundColor(Theme.color.accentDarkText)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Theme.color.accentLightBackground)
        .clipShape(Capsule())

      // 右侧分割线
      Rectangle()
        .fill(Theme.color.border)
        .frame(height: 1)

      Spacer()
    }
    .padding(.bottom, Theme.spacing.md)
  }
}

struct JournalItemView: View {
  let content: String
  let time: String
  let tags: [String]
  var images: [String] = []

  var body: some View {
    VStack(alignment: .leading, spacing: Theme.spacing.md) {
      // 1. 文本内容 (大号，深色)
      Text(content)
        .font(Theme.font.body)  // 稍微大一点的正文
        .foregroundColor(Theme.color.foreground)
        .lineSpacing(6)
        .fixedSize(horizontal: false, vertical: true)

      // 2. 图片区域 (模拟)
      if !images.isEmpty {
        HStack(spacing: Theme.spacing.sm) {
          ForEach(0..<2) { _ in
            RoundedRectangle(cornerRadius: Theme.radius.md)
              .fill(
                LinearGradient(
                  colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .frame(height: 120)
              .frame(maxWidth: .infinity)
          }
        }
      }

      // 3. 底部元数据 (时间 + 标签)
      HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.sm) {
        Text(time)
          .font(Theme.font.caption2)
          .foregroundColor(Theme.color.foregroundTertiary)

        // 使用 ForEach 替代 TagFlowLayout，避免布局 bug
        ForEach(tags, id: \.self) { tag in
          TagCapsule(tag)
        }

        Spacer()

        // 更多操作菜单点点点
        Image(systemName: "ellipsis")
          .font(.system(size: 14))
          .foregroundColor(Theme.color.foregroundTertiary)
      }
    }
    .padding(.vertical, Theme.spacing.md)
  }
}

// MARK: - Preview

#Preview("设计系统") {
  DesignSystemPreview()
}
