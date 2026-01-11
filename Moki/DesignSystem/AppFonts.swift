import SwiftUI
import UIKit

struct AppFonts {

  // MARK: - Noto Serif SC 宋体字重

  private enum SerifFontName {
    static let black = "NotoSerifSC-Black"
    static let bold = "NotoSerifSC-Bold"
    static let semibold = "NotoSerifSC-SemiBold"
    static let medium = "NotoSerifSC-Medium"
    static let regular = "NotoSerifSC-Regular"
    static let light = "NotoSerifSC-Light"
    static let extraLight = "NotoSerifSC-ExtraLight"
  }

  /// 映射 Font.Weight → 宋体字体名
  private static func serifFontName(for weight: Font.Weight) -> String {
    switch weight {
    case .black, .heavy: SerifFontName.black
    case .bold: SerifFontName.bold
    case .semibold: SerifFontName.semibold
    case .medium: SerifFontName.medium
    case .light: SerifFontName.light
    case .thin, .ultraLight: SerifFontName.extraLight
    default: SerifFontName.regular
    }
  }

  /// 宋体字体，用于日记正文等需要阅读体验的场景
  /// - Parameters:
  ///   - size: 字体大小
  ///   - weight: 字重，默认 .regular
  static func serif(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
    Font.custom(serifFontName(for: weight), fixedSize: size)
  }

  // MARK: - 日记正文（宋体）

  /// 日记正文 - 宋体，阅读性优先
  static let journalBody = serif(17)

  /// 日记正文 UIFont 版本（UIKit 组件使用）
  static let journalBodyUIFont: UIFont =
    UIFont(name: SerifFontName.regular, size: 17) ?? UIFont.systemFont(ofSize: 17)

  /// 日记正文行高系数
  static let journalBodyLineSpacing: CGFloat = 10

  /// 日记正文字间距
  static let journalBodyKerning: CGFloat = 1.1

  // MARK: - 日期字体（系统字体）

  /// 日期大数字 - 视觉锚点
  static let dateLarge = serif(36, weight: .semibold)

  /// 日期小标签 - 辅助信息 (月份/星期)
  static let dateSmall: Font = serif(14, weight: .medium)

  // MARK: - 标题字体（系统字体）

  /// 顶栏标题（UIKit / UINavigationBarAppearance 用）
  static let headerTitleUIFont = UIFont.systemFont(ofSize: 18, weight: .bold)

  /// 品牌标题（宋体）
  static let brandTitle: Font = serif(40, weight: .semibold)

  /// 品牌副标题（Georgia 斜体）
  static let brandSubtitle: Font = .custom("Georgia-Italic", size: 16)

  /// 一级标题
  static let title1: Font = .system(size: 30, weight: .bold)

  /// 二级标题
  static let title2: Font = .system(size: 24, weight: .semibold)

  /// 三级标题
  static let title3: Font = .system(size: 20, weight: .medium)

  /// 四级标题
  static let title4: Font = .system(size: 18, weight: .medium)

  static let menuItemTitle: Font = .system(size: 18)

  /// 正文
  static let body: Font = .system(size: 17)

  /// 副文本
  static let callout: Font = .system(size: 16)

  /// 次要文本
  static let subheadline: Font = .system(size: 15)

  /// 脚注
  static let footnote: Font = .system(size: 14)

  /// 说明文字
  static let caption: Font = .system(size: 12)

  /// 极小文字
  static let caption2: Font = .system(size: 11)

  /// 微型文字
  static let micro: Font = .system(size: 10)

  // MARK: - 特殊字体（系统字体）

  /// 按钮字体
  static let button: Font = .system(size: 17, weight: .medium)
}

// MARK: - 宋体修饰符

extension View {
  /// 应用宋体字体
  /// - Parameters:
  ///   - size: 字体大小
  ///   - weight: 字重，默认 .regular
  func serifFont(_ size: CGFloat, weight: Font.Weight = .regular) -> some View {
    self.font(AppFonts.serif(size, weight: weight))
  }
}
