import SwiftUI
import UIKit

struct AppFonts {

  // MARK: - 字体名常量

  private enum FontName {
    static let black = "NotoSerifSC-Black"
    static let bold = "NotoSerifSC-Bold"
    static let semibold = "NotoSerifSC-SemiBold"
    static let medium = "NotoSerifSC-Medium"
    static let regular = "NotoSerifSC-Regular"
    static let light = "NotoSerifSC-Light"
    static let extraLight = "NotoSerifSC-ExtraLight"
  }

  // MARK: - Noto Serif SC 便捷封装

  /// 通用 Serif 字体，按权重映射到已打包的静态字重
  static func serif(
    _ size: CGFloat,
    weight: Font.Weight = .regular,
    relativeTo style: Font.TextStyle = .body
  ) -> Font {
    Font.custom(fontName(for: weight), size: size, relativeTo: style)
  }

  /// 映射 Font.Weight → 字体名
  private static func fontName(for weight: Font.Weight) -> String {
    switch weight {
    case .black, .heavy: FontName.black
    case .bold: FontName.bold
    case .semibold: FontName.semibold
    case .medium: FontName.medium
    case .light: FontName.light
    case .thin, .ultraLight: FontName.extraLight
    default: FontName.regular
    }
  }

  // MARK: - 日期字体

  /// 日期大数字 - 视觉锚点
  static let dateLarge = serif(36, weight: .semibold, relativeTo: .largeTitle)

  /// 日期小标签 - 辅助信息 (月份/星期)
  static let dateSmall = serif(14, weight: .medium, relativeTo: .footnote)

  /// 日期标题 (月份分组)
  static let dateTitle = serif(26, weight: .bold, relativeTo: .title)

  // MARK: - 内容字体

  /// 日记正文 - 阅读性优先
  static let journalBody = serif(17, weight: .regular, relativeTo: .body)

  /// 日记正文 UIFont 版本（UIKit 组件使用）
  static let journalBodyUIFont: UIFont =
    UIFont(name: FontName.regular, size: 17) ?? UIFont.systemFont(ofSize: 17)

  /// 日记正文行高系数
  static let journalBodyLineSpacing: CGFloat = 10

  /// 日记正文字间距
  static let journalBodyKerning: CGFloat = 1.1

  // MARK: - 标题字体

  /// 顶栏标题（UIKit / UINavigationBarAppearance 用）
  static let headerTitleUIFont =
    UIFont(name: FontName.bold, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)

  /// 一级标题
  static let title1 = serif(30, weight: .bold, relativeTo: .title)

  /// 二级标题
  static let title2 = serif(24, weight: .semibold, relativeTo: .title2)

  /// 三级标题
  static let title3 = serif(20, weight: .medium, relativeTo: .title3)

  /// 四级标题
  static let title4 = serif(18, weight: .medium, relativeTo: .headline)

  // MARK: - 正文字体

  /// 正文
  static let body = serif(17, weight: .regular, relativeTo: .body)

  /// 副文本
  static let callout = serif(16, weight: .regular, relativeTo: .callout)

  /// 次要文本
  static let subheadline = serif(15, weight: .regular, relativeTo: .subheadline)

  /// 脚注
  static let footnote = serif(14, weight: .regular, relativeTo: .footnote)

  /// 说明文字
  static let caption = serif(12, weight: .regular, relativeTo: .caption)

  /// 极小文字
  static let caption2 = serif(11, weight: .regular, relativeTo: .caption2)

  /// 微型文字
  static let micro = serif(10, weight: .regular, relativeTo: .caption2)

  // MARK: - 特殊字体

  /// 按钮字体
  static let button = serif(17, weight: .medium, relativeTo: .body)
}
