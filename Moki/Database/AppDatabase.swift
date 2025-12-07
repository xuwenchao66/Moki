//
//  AppDatabase.swift
//  Moki
//
//  统一维护应用级别的 SQLite 数据库实例
//

import Foundation
import SQLiteData

enum AppDatabase {
  static let shared: DatabaseQueue = Self.makeShared()

  static func makeWriter() throws -> DatabaseQueue {
    let databaseURL = try makeDatabaseURL()
    let databaseQueue = try DatabaseQueue(path: databaseURL.path)
    try AppDatabaseMigrator.migrate(databaseQueue)
    return databaseQueue
  }

  private static func makeShared() -> DatabaseQueue {
    do {
      return try makeWriter()
    } catch {
      fatalError("无法初始化全局数据库: \(error)")
    }
  }

  private static func makeDatabaseURL() throws -> URL {
    let fileManager = FileManager.default
    let baseURL = try fileManager.url(
      for: .applicationSupportDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
    )

    let directory = baseURL.appendingPathComponent("Database", isDirectory: true)
    if fileManager.fileExists(atPath: directory.path) == false {
      try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    let databaseURL = directory.appendingPathComponent("moki.sqlite")

    // TD: 移除此逻辑。当前为了便于调试，每次初始化都删除旧数据库文件。
    // if fileManager.fileExists(atPath: databaseURL.path) {
    //   try fileManager.removeItem(at: databaseURL)
    // }

    return databaseURL
  }
}
