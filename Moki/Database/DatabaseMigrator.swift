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

    // 新增 Tags 相关表结构迁移
    migrator.registerMigration("create-tags-tables") { db in
      // 1. 创建标签表
      try #sql(
        """
        CREATE TABLE "tags" (
          "id" TEXT NOT NULL PRIMARY KEY,
          "name" TEXT NOT NULL UNIQUE,
          "color" TEXT,
          "createdAt" TEXT NOT NULL
        ) STRICT
        """
      )
      .execute(db)

      // 2. 创建日记-标签关联表 (多对多)
      try #sql(
        """
        CREATE TABLE "diary_tags" (
          "diaryId" TEXT NOT NULL,
          "tagId" TEXT NOT NULL,
          PRIMARY KEY ("diaryId", "tagId"),
          FOREIGN KEY ("diaryId") REFERENCES "diaries"("id") ON DELETE CASCADE,
          FOREIGN KEY ("tagId") REFERENCES "tags"("id") ON DELETE CASCADE
        ) STRICT
        """
      )
      .execute(db)

      // 3. 创建索引以加速标签查询
      try #sql(
        """
        CREATE INDEX "idx_diary_tags_tagId" ON "diary_tags" ("tagId")
        """
      )
      .execute(db)
    }

    return migrator
  }
}
