//
//  AppColors.swift
//  Moki
//
//  设计系统 - 颜色定义
//  基于 X app 的极简黑白灰主题
//  仅支持浅色模式
//

import SwiftUI

struct AppColors {

  // MARK: - 主色调 (Primary)

  /// 主背景色 - 纯白
  static let background = Color.white

  /// 主前景色 - 深灰黑 (#0F1419)
  static let foreground = Color(red: 0x0F / 255.0, green: 0x14 / 255.0, blue: 0x19 / 255.0)

  /// 次要前景色 - 中灰
  static let foregroundSecondary = Color(red: 0x53 / 255.0, green: 0x5F / 255.0, blue: 0x6B / 255.0)

  /// 三级前景色 - 浅灰
  static let foregroundTertiary = Color(red: 0x9B / 255.0, green: 0xA3 / 255.0, blue: 0xAD / 255.0)

  // MARK: - 语义色 (Semantic)

  /// 边框色 - 极浅灰 (#EFF3F4)
  static let border = Color(red: 0xEF / 255.0, green: 0xF3 / 255.0, blue: 0xF4 / 255.0)

  /// 分割线 - 同边框色
  static let divider = border
}
