//
//  TagService.swift
//  Moki
//
//  标签相关的数据库操作
//

import Dependencies
import Foundation
import Logging
import SQLiteData

struct TagService {
  @Dependency(\.defaultDatabase) private var database

  // MARK: - 创建

  /// 创建新标签
  func create(_ tag: MokiTag) {
    do {
      try database.write { db in
        try MokiTag
          .insert { tag }
          .execute(db)
      }
      AppLogger.database.info("✅ 创建标签成功: \(tag.name)")
    } catch {
      AppLogger.database.error("❌ 创建标签失败", metadata: ["error": "\(error)"])
    }
  }

  // MARK: - 更新

  /// 更新标签信息
  func update(_ tag: MokiTag, name: String, color: String?) {
    do {
      try database.write { db in
        try MokiTag
          .update {
            $0.name = name
            $0.color = color
            $0.updatedAt = Date()
          }
          .where { $0.id.eq(tag.id) }
          .execute(db)
      }
      AppLogger.database.info("✅ 更新标签成功: \(name)")
    } catch {
      AppLogger.database.error("❌ 更新标签失败", metadata: ["error": "\(error)"])
    }
  }

  // MARK: - 删除

  /// 删除标签（级联删除所有关联）
  func delete(_ tag: MokiTag) {
    do {
      try database.write { db in
        try MokiTag
          .delete(tag)
          .execute(db)
      }
      AppLogger.database.info("✅ 删除标签成功: \(tag.name)")
    } catch {
      AppLogger.database.error("❌ 删除标签失败", metadata: ["error": "\(error)"])
    }
  }

  // MARK: - 关联管理

  /// 给日记添加标签
  func addTag(_ tag: MokiTag, toDiary diaryId: UUID, order: Int = 0) {
    do {
      try database.write { db in
        let association = MokiDiaryTag(
          diaryId: diaryId,
          tagId: tag.id,
          order: order
        )
        try MokiDiaryTag
          .insert { association }
          .execute(db)
      }
      AppLogger.database.info("✅ 添加标签关联: \(tag.name)")
    } catch {
      AppLogger.database.error("❌ 添加标签关联失败", metadata: ["error": "\(error)"])
    }
  }

  /// 从日记移除标签
  func removeTag(_ tag: MokiTag, fromDiary diaryId: UUID) {
    do {
      try database.write { db in
        // 复合主键表使用 SQL 删除
        try db.execute(
          sql: "DELETE FROM diary_tags WHERE diaryId = ? AND tagId = ?",
          arguments: [diaryId.uuidString, tag.id.uuidString]
        )
      }
      AppLogger.database.info("✅ 移除标签关联: \(tag.name)")
    } catch {
      AppLogger.database.error("❌ 移除标签关联失败", metadata: ["error": "\(error)"])
    }
  }

  /// 更新日记的标签列表（批量操作）
  func updateTags(_ tags: [MokiTag], forDiary diaryId: UUID) {
    do {
      try database.write { db in
        // 1. 删除所有现有关联
        try db.execute(
          sql: "DELETE FROM diary_tags WHERE diaryId = ?",
          arguments: [diaryId.uuidString]
        )

        // 2. 添加新关联（按顺序）
        for (index, tag) in tags.enumerated() {
          let association = MokiDiaryTag(
            diaryId: diaryId,
            tagId: tag.id,
            order: index
          )
          try MokiDiaryTag
            .insert { association }
            .execute(db)
        }
      }
      AppLogger.database.info("✅ 更新日记标签: \(tags.count) 个")
    } catch {
      AppLogger.database.error("❌ 更新日记标签失败", metadata: ["error": "\(error)"])
    }
  }
}
