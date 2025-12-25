//
//  DatabaseMigrator.swift
//  Moki
//
//  数据库迁移（MVP 简化版本）
//  开发阶段：修改 Schema 后删除 App 重装即可
//

import Foundation
import SQLiteData

enum AppDatabaseMigrator {
  static func migrate(_ database: DatabaseWriter) throws {
    try migrator().migrate(database)
  }

  static func migrator() -> SQLiteData.DatabaseMigrator {
    var migrator = DatabaseMigrator()

    // MVP 阶段：所有表结构在一个迁移中定义
    // 修改 Schema 时直接改这里，然后删除 App 重装测试
    migrator.registerMigration("v1") { db in
      // 1. 日记表
      try db.create(table: "diaries") { t in
        t.primaryKey("id", .text)
        t.column("text", .text).notNull()
        t.column("createdAt", .text).notNull().defaults(sql: "CURRENT_TIMESTAMP")
        t.column("updatedAt", .text)
        t.column("deletedAt", .text)  // 软删除时间戳
        t.column("isStarred", .boolean).notNull().defaults(to: false)
        t.column("timeZone", .text).notNull().defaults(to: TimeZone.current.identifier)  // 默认当前时区
        t.column("metadata", .text).notNull().defaults(to: "{}")  // JSON 扩展字段
      }

      // 2. 标签表
      try db.create(table: "tags") { t in
        t.primaryKey("id", .text)
        t.column("name", .text).notNull().unique()  // 名称唯一
        t.column("color", .text)
        t.column("order", .integer).notNull().defaults(to: 0)  // 排序
        t.column("createdAt", .text).notNull()
        t.column("updatedAt", .text)
        t.column("metadata", .text).notNull().defaults(to: "{}")  // JSON 扩展字段
      }

      // 3. 日记-标签关联表（多对多）
      try db.create(table: "diary_tags") { t in
        t.column("diaryId", .text).notNull()
        t.column("tagId", .text).notNull()
        t.column("order", .integer).notNull().defaults(to: 0)  // 排序
        t.column("createdAt", .text).notNull().defaults(sql: "CURRENT_TIMESTAMP")
        t.primaryKey(["diaryId", "tagId"])  // 复合主键，防止重复关联
        t.foreignKey(["diaryId"], references: "diaries", columns: ["id"], onDelete: .cascade)
        t.foreignKey(["tagId"], references: "tags", columns: ["id"], onDelete: .cascade)
      }

      // 4. 创建索引优化查询性能
      // 索引1：按标签筛选日记（点击标签 → 查看所有相关日记）
      try db.create(index: "idx_diary_tags_tagId", on: "diary_tags", columns: ["tagId"])
      // 索引2：显示日记的标签列表并排序（打开日记 → 显示其所有标签）
      try db.create(
        index: "idx_diary_tags_diaryId_order",
        on: "diary_tags",
        columns: ["diaryId", "order"]
      )
    }

    return migrator
  }
}

// MARK: - 开发提示

/*
 📝 MVP 阶段数据库修改流程：

 1. 修改 Schema.swift 中的数据模型
 2. 修改上面 v1 迁移中的表结构
 3. 删除 App（或清除模拟器数据）
 4. 重新运行，数据库会自动重建

 ⚠️ 注意：这种方式会丢失所有数据，仅适合开发阶段

 🎯 什么时候需要增量迁移？
 - 有了真实用户数据（100+ 条日记）
 - Schema 基本稳定
 - 准备正式发布时

 到那时再添加 v2, v3... 等增量迁移即可
 */
