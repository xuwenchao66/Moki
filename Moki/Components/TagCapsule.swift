//
//  TagCapsule.swift
//  Moki
//
//  标签胶囊组件
//  遵循 "钢笔圈画" 理念：使用文字颜色而非色块背景
//

import SwiftUI

/// 标签胶囊组件
struct TagCapsule: View {
    let text: String
    let color: Color
    var style: TagStyle = .outlined
    
    init(_ text: String, color: Color = Theme.color.accent, style: TagStyle = .outlined) {
        self.text = text
        self.color = color
        self.style = style
    }
    
    var body: some View {
        Group {
            switch style {
            case .outlined:
                outlinedTag
            case .text:
                textTag
            case .filled:
                filledTag
            }
        }
    }
    
    // MARK: - Style Variants
    
    /// 描边样式 - 推荐，符合 "钢笔圈画" 理念
    private var outlinedTag: some View {
        Text(text)
            .font(Theme.font.tag)
            .foregroundColor(color)
            .padding(.horizontal, Theme.spacing.sm)
            .padding(.vertical, Theme.spacing.xxs)
            .overlay(
                Capsule()
                    .strokeBorder(color.opacity(0.4), lineWidth: 1)
            )
    }
    
    /// 纯文字样式 - 最轻量
    private var textTag: some View {
        Text("#\(text)")
            .font(Theme.font.tag)
            .foregroundColor(color)
    }
    
    /// 填充样式 - 仅在需要强调时使用
    private var filledTag: some View {
        Text(text)
            .font(Theme.font.tag)
            .foregroundColor(.white)
            .padding(.horizontal, Theme.spacing.sm)
            .padding(.vertical, Theme.spacing.xxs)
            .background(
                Capsule()
                    .fill(color)
            )
    }
}

/// 标签样式枚举
enum TagStyle {
    case outlined  // 描边（推荐）
    case text      // 纯文字
    case filled    // 填充（慎用）
}

// MARK: - Tag Flow Layout (标签流式布局)

/// 标签流式布局容器
struct TagFlowLayout: View {
    let tags: [String]
    let colors: [Color]
    let style: TagStyle
    var spacing: CGFloat = Theme.spacing.xs
    
    init(
        tags: [String],
        colors: [Color]? = nil,
        style: TagStyle = .outlined,
        spacing: CGFloat = Theme.spacing.xs
    ) {
        self.tags = tags
        self.colors = colors ?? Theme.color.tagColors
        self.style = style
        self.spacing = spacing
    }
    
    var body: some View {
        FlowLayout(spacing: spacing) {
            ForEach(Array(tags.enumerated()), id: \.offset) { index, tag in
                TagCapsule(
                    tag,
                    color: colors[index % colors.count],
                    style: style
                )
            }
        }
    }
}

/// 简易流式布局
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: result.positions[index], proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

// MARK: - Preview

#Preview("标签样式预览") {
    ScrollView {
        VStack(alignment: .leading, spacing: Theme.spacing.xl) {
            // 描边样式（推荐）
            VStack(alignment: .leading, spacing: Theme.spacing.sm) {
                Text("描边样式 - 推荐")
                    .titleStyle()
                Text("像钢笔圈画的感觉，保留呼吸感")
                    .captionStyle()
                
                TagFlowLayout(
                    tags: ["Naval", "幸福", "成长", "学习", "智慧"],
                    style: .outlined
                )
            }
            
            Separator()
            
            // 纯文字样式
            VStack(alignment: .leading, spacing: Theme.spacing.sm) {
                Text("纯文字样式")
                    .titleStyle()
                Text("最轻量，适合内联使用")
                    .captionStyle()
                
                TagFlowLayout(
                    tags: ["Naval", "幸福", "成长", "学习", "智慧"],
                    style: .text
                )
            }
            
            Separator()
            
            // 填充样式（慎用）
            VStack(alignment: .leading, spacing: Theme.spacing.sm) {
                Text("填充样式 - 慎用")
                    .titleStyle()
                Text("会打破视觉流动性，仅在需要强调时使用")
                    .captionStyle()
                
                TagFlowLayout(
                    tags: ["Naval", "幸福", "成长"],
                    style: .filled
                )
            }
            
            Separator()
            
            // 在卡片中的应用示例
            VStack(alignment: .leading, spacing: Theme.spacing.sm) {
                Text("实际应用示例")
                    .titleStyle()
                
                AppCard {
                    VStack(alignment: .leading, spacing: Theme.spacing.sm) {
                        Text("欲望是你跟自己签的协议：在得到你想要的东西之前，你一直不会快乐。")
                            .font(Theme.font.body)
                            .foregroundColor(Theme.color.foreground)
                        
                        HStack {
                            Text("23:42:15")
                                .captionStyle()
                            
                            Spacer()
                            
                            TagFlowLayout(
                                tags: ["Naval", "幸福"],
                                style: .outlined
                            )
                        }
                    }
                }
            }
        }
        .padding(Theme.spacing.lg)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.color.background)
}

