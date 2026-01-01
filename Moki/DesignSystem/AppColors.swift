// https://tweakcn.com/editor/theme?p=colors

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
  static let background = Color(hex: "faf9f5")

  /// 主前景色
  static let foreground = Color(hex: "3d3929")

  // MARK: - 主色调 (Primary)

  /// 主要强调色
  static let primary = Color(hex: "c96442")

  /// 主色前景色
  static let primaryForeground = Color(hex: "ffffff")

  // MARK: - 次要色 (Secondary)

  /// 次要色
  static let secondary = Color(hex: "e9e6dc")

  /// 次要色前景
  static let secondaryForeground = Color(hex: "535146")

  static let dateLargeForeground = Color(hex: "C7C1B8")

  // MARK: - 柔和色 (Muted)

  /// 柔和背景色
  static let muted = Color(hex: "ede9de")

  /// 柔和前景色
  static let mutedForeground = Color(hex: "83827d")

  // MARK: - 强调色 (Accent)

  /// 强调色
  static let accent = Color(hex: "e9e6dc")

  /// 强调色前景
  static let accentForeground = Color(hex: "28261b")

  static let card = Color(hex: "faf9f5")

  static let cardForeground = Color(hex: "141413")

  static let buttonBackground = Color(hex: "141413")

  // MARK: - 语义色 (Semantic)

  /// 边框色
  static let border = Color(hex: "dad9d4")

  /// 输入框边框色
  static let input = Color(hex: "b4b2a7")

  /// 焦点环颜色
  static let ring = Color(hex: "c96442")

  // MARK: - 警示色 (Destructive)

  /// 危险/删除操作色
  static let destructive = Color(hex: "1A1D20")

  /// 危险操作前景色
  static let destructiveForeground = Color(hex: "FFFFFF")
}
