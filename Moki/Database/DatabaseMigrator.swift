//
//  DatabaseMigrator.swift
//  Moki
//
//  维护所有数据库迁移及种子数据
//

import Foundation
import SQLiteData

enum AppDatabaseMigrator {
  static func migrate(_ database: DatabaseWriter) throws {
    try migrator().migrate(database)
  }

  static func migrator() -> SQLiteData.DatabaseMigrator {
    var migrator = DatabaseMigrator()

    migrator.registerMigration("Create initial tables") { db in
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
      let entryCount = try MokiDiary.count().fetchOne(db) ?? 0
      guard entryCount == 0 else { return }

      let welcomeEntry = MokiDiary.welcomeEntry
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

    return migrator
  }
}
