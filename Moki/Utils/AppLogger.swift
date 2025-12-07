//
//  AppLogger.swift
//  Moki
//
//  统一的日志管理系统
//  使用 swift-log 提供标准化的日志输出
//

import Foundation
import Logging

/// 应用日志管理器
enum AppLogger {
  /// 数据库相关日志
  static let database = Logger(label: "com.moki.database")

  /// UI 相关日志
  static let ui = Logger(label: "com.moki.ui")

  /// 预览相关日志
  static let preview = Logger(label: "com.moki.preview")

  /// 通用日志
  static let general = Logger(label: "com.moki.general")

  /// 初始化日志系统
  static func configure() {
    #if DEBUG
      // 开发环境：显示所有级别的日志
      LoggingSystem.bootstrap { label in
        var handler = StreamLogHandler.standardOutput(label: label)
        handler.logLevel = .trace
        return handler
      }
    #else
      // 生产环境：只显示 warning 及以上级别
      LoggingSystem.bootstrap { label in
        var handler = StreamLogHandler.standardOutput(label: label)
        handler.logLevel = .warning
        return handler
      }
    #endif
  }
}
