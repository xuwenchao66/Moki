//
//  AppFonts.swift
//  Moki
//
//  设计系统 - 字体定义
//  简约风格 (统一无衬线字体)
//

import SwiftUI
import UIKit

struct AppFonts {

  // MARK: - 标题字体 (Headings)

  /// 特大标题 - 简约风格
  static let largeTitle = Font.system(size: 36, weight: .bold, design: .rounded)

  /// 日期标题 (月份分组) - 杂志感衬线体
  static let dateTitle = Font.system(size: 26, weight: .bold, design: .serif)

  /// 顶栏标题（UIKit / UINavigationBarAppearance 用）
  static let headerTitleUIFont: UIFont = {
    let size: CGFloat = 18
    let base = UIFont.systemFont(ofSize: size, weight: .bold)
    if let descriptor = base.fontDescriptor.withDesign(.serif) {
      return UIFont(descriptor: descriptor, size: size)
    }
    return base
  }()

  /// 一级标题 - 页面标题
  static let title1 = Font.system(size: 30, weight: .bold, design: .default)

  /// 二级标题 - 章节标题
  static let title2 = Font.system(size: 24, weight: .semibold, design: .default)

  /// 三级标题 - 卡片标题
  static let title3 = Font.system(size: 20, weight: .medium, design: .default)

  // MARK: - 正文字体 (Body)

  /// 正文
  static let body = Font.system(size: 17, weight: .regular, design: .default)

  /// 日记正文
  static let journalBody = Font.system(size: 17, weight: .regular, design: .serif)

  /// 正文强调
  static let bodyBold = Font.system(size: 17, weight: .semibold, design: .default)

  /// 副文本
  static let callout = Font.system(size: 16, weight: .regular, design: .default)

  /// 次要文本
  static let subheadline = Font.system(size: 15, weight: .regular, design: .default)

  /// 脚注
  static let footnote = Font.system(size: 13, weight: .regular, design: .default)

  /// 说明文字
  static let caption = Font.system(size: 12, weight: .regular, design: .default)

  /// 极小文字
  static let caption2 = Font.system(size: 11, weight: .regular, design: .default)

  /// 微型文字
  static let micro = Font.system(size: 10, weight: .regular, design: .default)

  // MARK: - 特殊字体 (Special)

  /// 按钮字体
  static let button = Font.system(size: 17, weight: .medium, design: .default)
}

// MARK: - Font Weight Extension

extension Font.Weight {
  static let ultraLight = Font.Weight.ultraLight
  static let thin = Font.Weight.thin
  static let light = Font.Weight.light
  static let regular = Font.Weight.regular
  static let medium = Font.Weight.medium
  static let semibold = Font.Weight.semibold
  static let bold = Font.Weight.bold
  static let heavy = Font.Weight.heavy
  static let black = Font.Weight.black
}
