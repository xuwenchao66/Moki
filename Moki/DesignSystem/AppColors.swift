//
//  AppColors.swift
//  Moki
//
//  设计系统 - 颜色定义
//  基于 Claude 主题 + 木几日记的温暖美学
//

import SwiftUI

struct AppColors {
    
    // MARK: - 主色调 (Primary)
    // 温暖的米色系，呼应"木几"的木质感
    
    /// 主背景色 - 纸张般的暖白色
    static let background = Color(hex: "F9F7F4")
    
    /// 卡片背景色 - 稍微提亮的白色
    static let cardBackground = Color.white
    
    /// 主前景色 - 深棕灰色（文字主色）
    static let foreground = Color(hex: "2C2825")
    
    /// 次要前景色 - 中灰色（辅助文字）
    static let foregroundSecondary = Color(hex: "6B6560")
    
    /// 三级前景色 - 浅灰色（时间戳等）
    static let foregroundTertiary = Color(hex: "A39E9A")
    
    
    // MARK: - 强调色 (Accent)
    // 琥珀色系，温暖而不刺眼
    
    /// 主强调色 - 琥珀橙
    static let accent = Color(hex: "E8926B")
    
    /// 强调色前景
    static let accentForeground = Color.white
    
    /// 次要强调色 - 木棕色
    static let accentSecondary = Color(hex: "9B7E69")
    
    
    // MARK: - 语义色 (Semantic)
    
    /// 边框色 - 极淡的分割线
    static let border = Color(hex: "E8E3DF")
    
    /// 分割线 - 比边框稍深一点
    static let divider = Color(hex: "D8D3CF")
    
    /// 悬浮/按压态 - 米色遮罩
    static let hover = Color(hex: "F0EBE6")
    
    /// 选中态背景
    static let selected = Color(hex: "FFF4ED")
    
    
    // MARK: - 功能色 (Functional)
    
    /// 成功色 - 莫兰迪绿
    static let success = Color(hex: "7FA383")
    
    /// 警告色 - 莫兰迪黄
    static let warning = Color(hex: "D9B382")
    
    /// 错误色 - 莫兰迪红
    static let destructive = Color(hex: "C87E78")
    
    
    // MARK: - 标签颜色 (Tags)
    // 参考 "钢笔圈画" 的概念，使用淡雅的文字颜色而非色块
    
    static let tagColors: [Color] = [
        Color(hex: "E8926B"), // 琥珀橙
        Color(hex: "9B7E69"), // 木棕
        Color(hex: "7FA383"), // 莫兰迪绿
        Color(hex: "8B9EB7"), // 莫兰迪蓝
        Color(hex: "C3A6B1"), // 莫兰迪粉
        Color(hex: "B8956A"), // 暖金色
    ]
    
    
    // MARK: - 暗色模式 (Dark Mode)
    // 保持温暖感，而非纯黑
    
    struct Dark {
        /// 暗色背景 - 深木炭色
        static let background = Color(hex: "1C1816")
        
        /// 暗色卡片背景
        static let cardBackground = Color(hex: "2C2825")
        
        /// 暗色前景 - 暖白色
        static let foreground = Color(hex: "F0EBE6")
        
        /// 暗色次要前景
        static let foregroundSecondary = Color(hex: "A39E9A")
        
        /// 暗色边框
        static let border = Color(hex: "3C3835")
    }
}


// MARK: - Color Extension (Hex Support)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

