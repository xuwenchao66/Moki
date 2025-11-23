//
//  ViewModifiers.swift
//  Moki
//
//  通用视图修饰符
//  提供一致的 UI 样式，如 .cardStyle()、.buttonStyle() 等
//

import SwiftUI

// MARK: - Card Style (卡片样式)

extension View {
    /// 应用标准卡片样式
    /// - Parameters:
    ///   - padding: 内边距 (默认 Theme.spacing.md)
    ///   - radius: 圆角 (默认 Theme.radius.md)
    ///   - shadow: 阴影样式 (默认 Theme.shadow.sm)
    func cardStyle(
        padding: CGFloat = Theme.spacing.md,
        radius: CGFloat = Theme.radius.md,
        shadow: ShadowStyle = Theme.shadow.sm
    ) -> some View {
        self
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
    
    /// 轻量卡片样式 - 仅背景和圆角，无阴影
    func cardLightStyle(
        padding: CGFloat = Theme.spacing.md,
        radius: CGFloat = Theme.radius.md
    ) -> some View {
        self
            .padding(padding)
            .background(Theme.color.cardBackground)
            .cornerRadius(radius)
    }
}


// MARK: - Button Styles (按钮样式)

/// 主按钮样式 - 强调色填充
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.font.button)
            .foregroundColor(Theme.color.accentForeground)
            .padding(.horizontal, Theme.spacing.lg)
            .padding(.vertical, Theme.spacing.sm)
            .background(Theme.color.accent)
            .cornerRadius(Theme.radius.md)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

/// 次要按钮样式 - 描边
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.font.button)
            .foregroundColor(Theme.color.foreground)
            .padding(.horizontal, Theme.spacing.lg)
            .padding(.vertical, Theme.spacing.sm)
            .background(Theme.color.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radius.md)
                    .stroke(Theme.color.border, lineWidth: 1.5)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

/// 文本按钮样式 - 纯文字
struct TextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.font.button)
            .foregroundColor(Theme.color.accent)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension View {
    /// 应用主按钮样式
    func primaryButtonStyle() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
    
    /// 应用次要按钮样式
    func secondaryButtonStyle() -> some View {
        self.buttonStyle(SecondaryButtonStyle())
    }
    
    /// 应用文本按钮样式
    func textButtonStyle() -> some View {
        self.buttonStyle(TextButtonStyle())
    }
}


// MARK: - Text Styles (文字样式)

extension View {
    /// 主标题样式
    func titleStyle() -> some View {
        self
            .font(Theme.font.title2)
            .foregroundColor(Theme.color.foreground)
    }
    
    /// 副标题样式
    func subtitleStyle() -> some View {
        self
            .font(Theme.font.subheadline)
            .foregroundColor(Theme.color.foregroundSecondary)
    }
    
    /// 说明文字样式
    func captionStyle() -> some View {
        self
            .font(Theme.font.caption)
            .foregroundColor(Theme.color.foregroundTertiary)
    }
}


// MARK: - Separator (分割线)

struct Separator: View {
    var color: Color = Theme.color.divider
    var height: CGFloat = 1
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
    }
}


// MARK: - Spacer Helpers

extension View {
    /// 添加垂直间距
    func vSpacing(_ spacing: CGFloat) -> some View {
        self.padding(.vertical, spacing)
    }
    
    /// 添加水平间距
    func hSpacing(_ spacing: CGFloat) -> some View {
        self.padding(.horizontal, spacing)
    }
}


// MARK: - Conditional Modifiers

extension View {
    /// 条件修饰符
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

