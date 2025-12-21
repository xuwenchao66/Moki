//
//  AppTheme.swift
//  Moki
//
//  设计系统 - 统一主题入口
//  基于 Claude 的温暖橙色风格，支持浅色和深色模式
//  提供便捷访问: Theme.color.xxx, Theme.font.xxx
//

import SwiftUI

/// 主题命名空间 - 全局访问点
enum Theme {
  /// 颜色系统
  static let color = AppColors.self

  /// 字体系统
  static let font = AppFonts.self

  /// 间距系统
  static let spacing = Spacing.self

  /// 圆角系统
  static let radius = Radius.self

  /// 阴影系统
  static let shadow = Shadow.self
}

// MARK: - Spacing (间距系统)
// 基于 8px 网格系统,消除魔法数值

struct Spacing {
  /// 微小间距 - 2pt
  static let xxxs: CGFloat = 2

  /// 极小间距 - 4pt (微调)
  static let xxs: CGFloat = 4

  /// 稍小间距 - 6pt (紧凑布局)
  static let compact: CGFloat = 6

  /// 很小间距 - 8pt (元素内间距)
  static let xs: CGFloat = 8

  /// 小间距 - 12pt
  static let sm: CGFloat = 12

  /// 默认间距 - 16pt (常规间距,标准槽)
  static let md: CGFloat = 16

  /// 中等间距 - 20pt (页面边距)
  static let md2: CGFloat = 20

  /// 大间距 - 24pt (区块间距)
  static let lg: CGFloat = 24

  /// 大间距 - 28pt (区块间距)
  static let lg2: CGFloat = 28

  /// 很大间距 - 32pt
  static let xl: CGFloat = 32

  /// 很大间距 - 36pt (区块间距)
  static let xl2: CGFloat = 36

  /// 超大间距 - 48pt (大留白,代替分割线)
  static let xxl: CGFloat = 48

  /// 超大间距 - 60pt (日记条目之间的奢侈留白)
  static let xxxl: CGFloat = 60

  // MARK: - Semantic Spacing (语义化间距)

  /// 文本行间距 - 优化阅读体验 (8pt)
  static let textLineSpacing: CGFloat = 8
}

// MARK: - Radius (圆角系统)

struct Radius {
  /// 无圆角
  static let none: CGFloat = 0

  /// 极小圆角 - 2pt
  static let xxs: CGFloat = 2

  /// 很小圆角 - 4pt
  static let xs: CGFloat = 4

  /// 小圆角 - 6pt
  static let sm: CGFloat = 6

  /// 默认圆角 - 8pt (卡片 - Unfold 风格)
  static let md: CGFloat = 8

  /// 大圆角 - 12pt
  static let lg: CGFloat = 12

  /// 很大圆角 - 16pt
  static let xl: CGFloat = 16

  /// 圆形 - 9999pt
  static let full: CGFloat = 9999
}

// MARK: - Shadow (阴影系统)

struct Shadow {
  /// 无阴影
  static let none = ShadowStyle(
    color: .clear,
    radius: 0,
    x: 0,
    y: 0
  )

  /// 极小阴影 - 悬浮感
  static let xs = ShadowStyle(
    color: Color.black.opacity(0.04),
    radius: 2,
    x: 0,
    y: 1
  )

  /// 小阴影 - 卡片
  static let sm = ShadowStyle(
    color: Color.black.opacity(0.06),
    radius: 4,
    x: 0,
    y: 2
  )

  /// 默认阴影 - 浮起的卡片
  static let md = ShadowStyle(
    color: Color.black.opacity(0.08),
    radius: 8,
    x: 0,
    y: 4
  )

  /// 柔和阴影 - 平静的卡片
  static let soft = ShadowStyle(
    color: Color.black.opacity(0.04),
    radius: 6,
    x: 0,
    y: 2
  )

  /// 大阴影 - 弹出层
  static let lg = ShadowStyle(
    color: Color.black.opacity(0.10),
    radius: 16,
    x: 0,
    y: 8
  )

  /// 超大阴影 - 模态窗口
  static let xl = ShadowStyle(
    color: Color.black.opacity(0.12),
    radius: 24,
    x: 0,
    y: 12
  )
}

/// 阴影样式
struct ShadowStyle {
  let color: Color
  let radius: CGFloat
  let x: CGFloat
  let y: CGFloat
}

// MARK: - Environment Values Extension

extension EnvironmentValues {
  /// 自定义环境值：用户主题偏好（保留以防未来需要）
  var userColorScheme: ColorScheme? {
    get { self[UserColorSchemeKey.self] }
    set { self[UserColorSchemeKey.self] = newValue }
  }
}

private struct UserColorSchemeKey: EnvironmentKey {
  static let defaultValue: ColorScheme? = .light
}
