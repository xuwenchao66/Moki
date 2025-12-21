//
//  AppColors.swift
//  Moki
//
//  设计系统 - 颜色定义
//  基于 Claude 的温暖风格主题
//  支持浅色和深色模式
//

import SwiftUI

struct AppColors {

  // MARK: - 基础色 (Foundation)

  /// 主背景色
  static let background = Color("Background")

  /// 主前景色
  static let foreground = Color("Foreground")

  // MARK: - 主色调 (Primary)

  /// 主要强调色
  static let primary = Color("Primary")

  /// 主色前景色
  static let primaryForeground = Color("PrimaryForeground")

  // MARK: - 次要色 (Secondary)

  /// 次要色
  static let secondary = Color("Secondary")

  /// 次要色前景
  static let secondaryForeground = Color("SecondaryForeground")

  // MARK: - 柔和色 (Muted)

  /// 柔和背景色
  static let muted = Color("Muted")

  /// 柔和前景色
  static let mutedForeground = Color("MutedForeground")

  // MARK: - 强调色 (Accent)

  /// 强调色
  static let accent = Color("Accent")

  /// 强调色前景
  static let accentForeground = Color("AccentForeground")

  // MARK: - 卡片 (Card)

  /// 卡片背景色
  static let card = Color("Card")

  /// 卡片前景色
  static let cardForeground = Color("CardForeground")

  // MARK: - 语义色 (Semantic)

  /// 边框色
  static let border = Color("Border")

  /// 分割线
  static let divider = border

  /// 输入框边框色
  static let input = Color("Input")

  /// 焦点环颜色
  static let ring = Color("Ring")

  // MARK: - 警示色 (Destructive)

  /// 危险/删除操作色
  static let destructive = Color("Destructive")

  /// 危险操作前景色
  static let destructiveForeground = Color("DestructiveForeground")
}
