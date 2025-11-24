//
//  Date+Extensions.swift
//  Moki
//
//  日期扩展工具
//  提供友好的日期格式化方法
//

import Foundation

extension Date {
  /// 转换为 Moki 标准日期字符串: "2025-11-23"
  func toMokiDateString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: self)
  }

  /// 转换为 Moki 标准时间字符串: "23:42:15"
  func toMokiTimeString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter.string(from: self)
  }

  /// 转换为友好的相对时间: "刚刚", "5分钟前", "昨天", "3天前"
  func toRelativeString() -> String {
    let now = Date()
    let interval = now.timeIntervalSince(self)

    // 未来时间
    if interval < 0 {
      return "未来"
    }

    // 1分钟内
    if interval < 60 {
      return "刚刚"
    }

    // 1小时内
    if interval < 3600 {
      let minutes = Int(interval / 60)
      return "\(minutes)分钟前"
    }

    // 今天
    if Calendar.current.isDateInToday(self) {
      let hours = Int(interval / 3600)
      return "\(hours)小时前"
    }

    // 昨天
    if Calendar.current.isDateInYesterday(self) {
      return "昨天"
    }

    // 7天内
    if interval < 7 * 24 * 3600 {
      let days = Int(interval / (24 * 3600))
      return "\(days)天前"
    }

    // 超过7天，显示日期
    return toMokiDateString()
  }

  /// 判断是否是今天
  var isToday: Bool {
    Calendar.current.isDateInToday(self)
  }

  /// 判断是否是本周
  var isThisWeek: Bool {
    Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
  }

  /// 判断是否是今年
  var isThisYear: Bool {
    Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
  }

  /// 获取"那年今日"的日期（去年的今天）
  static func oneYearAgo() -> Date {
    Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
  }
}


