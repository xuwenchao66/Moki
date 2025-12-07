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

    // 使用 Query Interface (推荐的 GRDB 方式)
    migrator.registerMigration("Create initial tables") { db in
      try db.create(table: "diaries") { t in
        t.primaryKey("id", .text)
        t.column("text", .text).notNull()
        t.column("createdAt", .text).notNull().defaults(sql: "CURRENT_TIMESTAMP")
        t.column("updatedAt", .text)
        t.column("isStarred", .boolean).notNull().defaults(to: false)
      }
    }

    // 新增 Tags 相关表结构迁移
    migrator.registerMigration("create-tags-tables") { db in
      // 1. 创建标签表
      try db.create(table: "tags") { t in
        t.primaryKey("id", .text)
        t.column("name", .text).notNull().unique()
        t.column("color", .text)
        t.column("createdAt", .text).notNull()
        t.column("updatedAt", .text)
      }

      // 2. 创建日记-标签关联表 (多对多)
      try db.create(table: "diary_tags") { t in
        t.column("diaryId", .text).notNull()
        t.column("tagId", .text).notNull()
        t.primaryKey(["diaryId", "tagId"])
        t.foreignKey(["diaryId"], references: "diaries", columns: ["id"], onDelete: .cascade)
        t.foreignKey(["tagId"], references: "tags", columns: ["id"], onDelete: .cascade)
      }

      // 3. 创建索引以加速标签查询
      try db.create(index: "idx_diary_tags_tagId", on: "diary_tags", columns: ["tagId"])
    }

    return migrator
  }
}
