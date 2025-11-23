//
//  AppFonts.swift
//  Moki
//
//  设计系统 - 字体定义
//  优雅、易读、具有文学气质
//

import SwiftUI

struct AppFonts {
    
    // MARK: - 标题字体 (Headings)
    
    /// 特大标题 - 用于品牌/欢迎页
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .serif)
    
    /// 一级标题 - 页面标题
    static let title1 = Font.system(size: 28, weight: .semibold, design: .rounded)
    
    /// 二级标题 - 章节标题
    static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    
    /// 三级标题 - 卡片标题
    static let title3 = Font.system(size: 20, weight: .medium, design: .rounded)
    
    
    // MARK: - 正文字体 (Body)
    
    /// 正文 - 日记内容主体
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    
    /// 正文强调
    static let bodyBold = Font.system(size: 17, weight: .semibold, design: .default)
    
    /// 副文本 - 辅助说明
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    
    /// 次要文本 - 元数据（时间、位置）
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    
    /// 脚注 - 版本号等
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    
    /// 说明文字 - 占位符、提示
    static let caption = Font.system(size: 12, weight: .regular, design: .default)
    
    /// 极小文字 - 时间戳等
    static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
    
    
    // MARK: - 特殊字体 (Special)
    
    /// 标签字体 - 小号圆体
    static let tag = Font.system(size: 13, weight: .medium, design: .rounded)
    
    /// 按钮字体
    static let button = Font.system(size: 16, weight: .semibold, design: .rounded)
    
    /// 等宽字体 - 用于代码、数字等
    static let monospaced = Font.system(size: 15, weight: .regular, design: .monospaced)
    
    
    // MARK: - 动态类型支持 (Dynamic Type)
    
    /// 自适应正文 - 跟随系统字号设置
    static var bodyAdaptive: Font {
        .system(.body, design: .default)
    }
    
    /// 自适应标题
    static var titleAdaptive: Font {
        .system(.title2, design: .rounded, weight: .semibold)
    }
}


// MARK: - Font Weight Extension

extension Font.Weight {
    /// 极细 (100)
    static let ultraLight = Font.Weight.ultraLight
    
    /// 纤细 (200)
    static let thin = Font.Weight.thin
    
    /// 细 (300)
    static let light = Font.Weight.light
    
    /// 常规 (400)
    static let regular = Font.Weight.regular
    
    /// 中等 (500)
    static let medium = Font.Weight.medium
    
    /// 半粗 (600)
    static let semibold = Font.Weight.semibold
    
    /// 粗 (700)
    static let bold = Font.Weight.bold
    
    /// 特粗 (800)
    static let heavy = Font.Weight.heavy
    
    /// 极粗 (900)
    static let black = Font.Weight.black
}

