//
//  AppColors.swift
//  Moki
//
//  设计系统 - 颜色定义
//  基于 Claude 的温暖风格主题
//  支持浅色和深色模式
//

import SwiftUI

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a: UInt64
    let r: UInt64
    let g: UInt64
    let b: UInt64
    switch hex.count {
    case 3:  // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6:  // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8:  // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }

    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}

struct AppColors {

  // MARK: - 基础色 (Foundation)

  /// 主背景色
  static let background = Color(hex: "F5F3EF")

  /// 主前景色
  static let foreground = Color(hex: "1A1A1A")

  // MARK: - 主色调 (Primary)

  /// 主要强调色
  static let primary = Color(hex: "D97757")

  /// 主色前景色
  static let primaryForeground = Color(hex: "FFFFFF")

  // MARK: - 次要色 (Secondary)

  /// 次要色
  static let secondary = Color(hex: "EBE8E1")

  /// 次要色前景
  static let secondaryForeground = Color(hex: "333333")

  // MARK: - 柔和色 (Muted)

  /// 柔和背景色
  static let muted = Color(hex: "E4E5E6")

  /// 柔和前景色
  static let mutedForeground = Color(hex: "999999")

  // MARK: - 卡片 (Card)

  /// 卡片背景色
  static let card = Color(hex: "F5F6F6")

  /// 卡片前景色
  static let cardForeground = Color(hex: "333333")

  // MARK: - 语义色 (Semantic)

  /// 边框色
  static let border = Color(hex: "000000").opacity(0.05)
}
