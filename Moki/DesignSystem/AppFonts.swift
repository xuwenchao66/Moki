import SwiftUI
import UIKit

struct AppFonts {

  // MARK: - 日记正文

  /// 日记正文 - 系统字体，亲和力优先
  static let journalBody: Font = .system(size: 17)

  /// 日记正文 UIFont 版本（UIKit 组件使用）
  static let journalBodyUIFont: UIFont = .systemFont(ofSize: 17)

  /// 日记正文行高系数
  static let journalBodyLineSpacing: CGFloat = 8

  /// 日记正文字间距
  static let journalBodyKerning: CGFloat = 0.4

  // MARK: - 日期字体

  /// 日期大数字 - 视觉锚点
  static let dateLarge: Font = .system(size: 36, weight: .semibold)

  // MARK: - 标题字体

  /// 顶栏标题（UIKit / UINavigationBarAppearance 用）
  static let headerTitleUIFont = UIFont.systemFont(ofSize: 18, weight: .bold)

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

  // MARK: - 特殊字体

  /// 按钮字体
  static let button: Font = .system(size: 17, weight: .medium)
}
