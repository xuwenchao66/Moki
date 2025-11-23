//
//  AppCard.swift
//  Moki
//
//  通用卡片容器
//  提供统一的卡片样式，承载内容
//

import SwiftUI

/// 通用卡片组件
struct AppCard<Content: View>: View {
    let content: Content
    var padding: CGFloat
    var radius: CGFloat
    var shadow: ShadowStyle
    
    init(
        padding: CGFloat = Theme.spacing.md,
        radius: CGFloat = Theme.radius.md,
        shadow: ShadowStyle = Theme.shadow.sm,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.radius = radius
        self.shadow = shadow
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(Theme.color.cardBackground)
            .cornerRadius(radius)
            .shadow(
                color: shadow.color,
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
    }
}

// MARK: - Preview

#Preview("卡片样式预览") {
    VStack(spacing: Theme.spacing.lg) {
        AppCard {
            VStack(alignment: .leading, spacing: Theme.spacing.xs) {
                Text("标准卡片")
                    .titleStyle()
                Text("这是一个标准的卡片样式，带有默认的内边距和阴影。")
                    .subtitleStyle()
            }
        }
        
        AppCard(padding: Theme.spacing.lg, shadow: Theme.shadow.md) {
            VStack(alignment: .leading, spacing: Theme.spacing.xs) {
                Text("大号卡片")
                    .titleStyle()
                Text("这是一个大号的卡片，有更大的内边距和阴影。")
                    .subtitleStyle()
            }
        }
        
        AppCard(padding: Theme.spacing.sm, shadow: Theme.shadow.xs) {
            HStack(spacing: Theme.spacing.sm) {
                Image(systemName: "heart.fill")
                    .foregroundColor(Theme.color.accent)
                Text("小巧卡片")
                    .font(Theme.font.callout)
                    .foregroundColor(Theme.color.foreground)
            }
        }
    }
    .padding(Theme.spacing.lg)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.color.background)
}

