//
//  EmptyStateView.swift
//  Moki
//
//  空状态占位图
//  提供友好的空状态提示
//

import SwiftUI

/// 空状态视图
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?
    
    init(
        icon: String = "doc.text",
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: Theme.spacing.lg) {
            Spacer()
            
            // 图标
            Image(systemName: icon)
                .font(.system(size: 64, weight: .light))
                .foregroundColor(Theme.color.foregroundTertiary)
            
            // 标题和描述
            VStack(spacing: Theme.spacing.xs) {
                Text(title)
                    .font(Theme.font.title3)
                    .foregroundColor(Theme.color.foreground)
                
                Text(message)
                    .font(Theme.font.callout)
                    .foregroundColor(Theme.color.foregroundSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // 操作按钮（可选）
            if let actionTitle = actionTitle, let action = action {
                AppButton(actionTitle, icon: "plus.circle.fill", style: .primary, action: action)
                    .padding(.top, Theme.spacing.sm)
            }
            
            Spacer()
        }
        .padding(Theme.spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#Preview("空状态预览") {
    VStack(spacing: 0) {
        // 无日记记录
        EmptyStateView(
            icon: "book.closed",
            title: "还没有日记",
            message: "开始记录你的第一条想法吧\n每一个当下都值得被记住",
            actionTitle: "创建第一条日记"
        ) {
            print("创建日记")
        }
        .frame(height: 400)
        .background(Theme.color.background)
        
        Separator()
        
        // 无搜索结果
        EmptyStateView(
            icon: "magnifyingglass",
            title: "没有找到相关内容",
            message: "试试其他关键词"
        )
        .frame(height: 400)
        .background(Theme.color.background)
    }
}

