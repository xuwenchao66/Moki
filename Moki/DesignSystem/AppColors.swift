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
  static let background = Color("background")

  /// 卡片背景色 - 稍微提亮的白色
  static let cardBackground = Color("cardBackground")

  /// 主前景色 - 深棕灰色（文字主色）
  static let foreground = Color("foreground")

  /// 次要前景色 - 中灰色（辅助文字）
  static let foregroundSecondary = Color("foregroundSecondary")

  /// 三级前景色 - 浅灰色（时间戳等）
  static let foregroundTertiary = Color("foregroundTertiary")

  // MARK: - 强调色 (Accent)
  // 琥珀色系，用于日期强调等

  /// 主强调色 - 琥珀橙 (用于日期胶囊背景等)
  static let accent = Color("accent")  // Claude Primary

  /// 强调色前景
  static let accentForeground = Color("accentForeground")

  /// 浅色强调背景 - (用于日期胶囊背景)
  static let accentLightBackground = Color("accentLightBackground")  // 柔和的陶土色背景

  /// 深色强调文本 - (用于日期胶囊文字)
  static let accentDarkText = Color("accentDarkText")  // Claude Primary

  // MARK: - 动作色 (Action)
  // 用于按钮、交互元素，统一为黑色

  /// 主动作色 - 黑色
  static let primaryAction = Color("primaryAction")

  /// 主动作前景 - 白色
  static let primaryActionForeground = Color("primaryActionForeground")

  // MARK: - 语义色 (Semantic)

  /// 边框色 - 极淡的分割线
  static let border = Color("border")

  /// 分割线 - 比边框稍深一点
  static let divider = Color("divider")

  /// 悬浮/按压态 - 米色遮罩
  static let hover = Color("hover")

  /// 选中态背景
  static let selected = Color("selected")

  // MARK: - 功能色 (Functional)

  /// 成功色 - 莫兰迪绿
  static let success = Color("success")

  /// 警告色 - 莫兰迪黄
  static let warning = Color("warning")

  /// 错误色 - 莫兰迪红
  static let destructive = Color("destructive")

  // MARK: - 标签颜色 (Tags)
  // 统一使用灰色，保持极简

  static let tagText = Color("tagText")  // 灰色文字
}
