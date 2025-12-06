//
//  AppColors.swift
//  Moki
//
//  设计系统 - 颜色定义
//  基于极简黑白灰主题 (Repov style)
//  引用 Assets.xcassets 中的颜色以支持暗黑模式
//

import SwiftUI

struct AppColors {

  // MARK: - 主色调 (Primary)

  /// 主背景色
  static let background = Color("background")

  /// 卡片背景色
  static let cardBackground = Color("cardBackground")

  /// 主前景色
  static let foreground = Color("foreground")

  /// 次要前景色
  static let foregroundSecondary = Color("foregroundSecondary")

  /// 三级前景色
  static let foregroundTertiary = Color("foregroundTertiary")

  // MARK: - 强调色 (Accent)

  /// 主强调色
  static let accent = Color("accent")

  /// 强调色前景
  static let accentForeground = Color("accentForeground")

  /// 浅色强调背景
  static let accentLightBackground = Color("accentLightBackground")

  // MARK: - 动作色 (Action)

  /// 主动作色
  static let primaryAction = Color("primaryAction")

  /// 主动作前景
  static let primaryActionForeground = Color("primaryActionForeground")

  // MARK: - 语义色 (Semantic)

  /// 边框色
  static let border = Color("border")

  /// 分割线
  static let divider = Color("divider")

  /// 悬浮/按压态
  static let hover = Color("hover")

  /// 选中态背景
  static let selected = Color("selected")

  // MARK: - 标签颜色 (Tags)

  static let tagText = Color("tagText")
}
