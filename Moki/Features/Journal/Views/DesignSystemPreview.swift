//
//  DesignSystemPreview.swift
//  Moki
//
//  设计系统预览页面
//  展示所有设计元素和组件
//

import SwiftUI

struct DesignSystemPreview: View {
    @State private var selectedTab = 0
    
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
                        Label("示例", systemImage: "doc.text")
                    }
                    .tag(2)
            }
            .navigationTitle("Moki 设计系统")
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
                    ColorSwatch("次要前景色", color: Theme.color.foregroundSecondary)
                    ColorSwatch("三级前景色", color: Theme.color.foregroundTertiary)
                }
                
                // 强调色
                ColorSection(title: "强调色 (Accent)") {
                    ColorSwatch("主强调色", color: Theme.color.accent)
                    ColorSwatch("强调色前景", color: Theme.color.accentForeground)
                    ColorSwatch("次要强调色", color: Theme.color.accentSecondary)
                }
                
                // 语义色
                ColorSection(title: "语义色 (Semantic)") {
                    ColorSwatch("边框色", color: Theme.color.border)
                    ColorSwatch("分割线", color: Theme.color.divider)
                    ColorSwatch("悬浮态", color: Theme.color.hover)
                    ColorSwatch("选中态", color: Theme.color.selected)
                }
                
                // 功能色
                ColorSection(title: "功能色 (Functional)") {
                    ColorSwatch("成功色", color: Theme.color.success)
                    ColorSwatch("警告色", color: Theme.color.warning)
                    ColorSwatch("错误色", color: Theme.color.destructive)
                }
                
                // 标签颜色
                ColorSection(title: "标签颜色 (Tags)") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: Theme.spacing.sm) {
                        ForEach(Array(Theme.color.tagColors.enumerated()), id: \.offset) { index, color in
                            ColorSwatch("Tag \(index + 1)", color: color)
                        }
                    }
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
                
                // 卡片
                VStack(alignment: .leading, spacing: Theme.spacing.md) {
                    Text("卡片 (Cards)")
                        .titleStyle()
                    
                    AppCard {
                        VStack(alignment: .leading, spacing: Theme.spacing.xs) {
                            Text("这是一个标准卡片")
                                .font(Theme.font.body)
                            Text("卡片可以承载各种内容")
                                .captionStyle()
                        }
                    }
                }
                
                Separator()
                
                // 标签
                VStack(alignment: .leading, spacing: Theme.spacing.md) {
                    Text("标签 (Tags)")
                        .titleStyle()
                    
                    VStack(alignment: .leading, spacing: Theme.spacing.md) {
                        Text("描边样式（推荐）")
                            .captionStyle()
                        TagFlowLayout(
                            tags: ["Naval", "幸福", "成长", "学习"],
                            style: .outlined
                        )
                        
                        Text("纯文字样式")
                            .captionStyle()
                        TagFlowLayout(
                            tags: ["Naval", "幸福", "成长", "学习"],
                            style: .text
                        )
                    }
                }
                
                Separator()
                
                // 空状态
                VStack(alignment: .leading, spacing: Theme.spacing.md) {
                    Text("空状态 (Empty State)")
                        .titleStyle()
                    
                    EmptyStateView(
                        icon: "book.closed",
                        title: "还没有内容",
                        message: "开始创建你的第一条记录吧",
                        actionTitle: "创建记录"
                    ) {}
                    .frame(height: 300)
                    .background(Theme.color.cardBackground)
                    .cornerRadius(Theme.radius.md)
                }
            }
            .padding(Theme.spacing.lg)
        }
        .background(Theme.color.background)
    }
}

// MARK: - 日记卡片示例

struct JournalCardExamplesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.spacing.md) {
                // 日期分组标题
                HStack {
                    Text("2025-11-23")
                        .font(Theme.font.subheadline)
                        .foregroundColor(Theme.color.accent)
                        .padding(.horizontal, Theme.spacing.md)
                        .padding(.vertical, Theme.spacing.xxs)
                        .background(Theme.color.selected)
                        .cornerRadius(Theme.radius.sm)
                    
                    Spacer()
                }
                .padding(.horizontal, Theme.spacing.lg)
                .padding(.top, Theme.spacing.lg)
                
                // 日记卡片列表
                ForEach(MockJournalData.sampleEntries.indices, id: \.self) { index in
                    let entry = MockJournalData.sampleEntries[index]
                    
                    AppCard(padding: Theme.spacing.md) {
                        VStack(alignment: .leading, spacing: Theme.spacing.sm) {
                            // 内容
                            Text(entry.content)
                                .font(Theme.font.body)
                                .foregroundColor(Theme.color.foreground)
                                .lineSpacing(6)
                            
                            // 底部信息栏
                            HStack(alignment: .center) {
                                // 时间
                                Text(entry.time)
                                    .font(Theme.font.caption)
                                    .foregroundColor(Theme.color.foregroundTertiary)
                                
                                Spacer()
                                
                                // 标签
                                TagFlowLayout(
                                    tags: entry.tags,
                                    style: .outlined
                                )
                            }
                        }
                    }
                    .padding(.horizontal, Theme.spacing.lg)
                }
                
                Spacer(minLength: Theme.spacing.xl)
            }
        }
        .background(Theme.color.background)
    }
}

// MARK: - Preview

#Preview("设计系统") {
    DesignSystemPreview()
}

#Preview("颜色系统") {
    ColorSystemView()
}

#Preview("组件库") {
    ComponentLibraryView()
}

#Preview("日记卡片") {
    JournalCardExamplesView()
}

