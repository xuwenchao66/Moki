//
//  JournalDatabase.swift
//  Moki
//
//  负责初始化 Journal 模块所需的 SQLite 数据库
//

import Foundation
import SQLiteData

extension DatabaseWriter where Self == DatabaseQueue {
  /// 按需创建或打开日记数据库，并执行迁移与初始化数据
  static var journalDatabase: Self {
    do {
      let databaseURL = try makeJournalDatabaseURL()
      let databaseQueue = try DatabaseQueue(path: databaseURL.path)
      try migrateAndSeed(databaseQueue)
      return databaseQueue
    } catch {
      fatalError("无法初始化日记数据库: \(error)")
    }
  }

  private static func makeJournalDatabaseURL() throws -> URL {
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

    return directory.appendingPathComponent("moki.sqlite")
  }

  private static func migrateAndSeed(_ database: DatabaseQueue) throws {
    var migrator = DatabaseMigrator()

    migrator.registerMigration("create-diaries") { db in
      try #sql(
        """
        CREATE TABLE IF NOT EXISTS "diaries" (
          "id" TEXT NOT NULL PRIMARY KEY,
          "text" TEXT NOT NULL,
          "createdAt" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          "modifiedAt" TEXT,
          "isStarred" INTEGER NOT NULL DEFAULT 0
        ) STRICT
        """
      )
      .execute(db)
    }

    migrator.registerMigration("seed-welcome-entry") { db in
      let entryCount = try JournalEntry.count().fetchOne(db) ?? 0
      guard entryCount == 0 else { return }

      let welcomeEntry = JournalEntry.welcomeEntry
      try #sql(
        """
        INSERT INTO "diaries" ("id", "text", "createdAt", "modifiedAt", "isStarred")
        VALUES (
          \(welcomeEntry.id.uuidString),
          \(welcomeEntry.text),
          \(welcomeEntry.createdAt),
          \(welcomeEntry.modifiedAt),
          \(welcomeEntry.isStarred)
        )
        """
      )
      .execute(db)
    }

    try migrator.migrate(database)
  }
}

