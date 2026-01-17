import Dependencies
import Foundation
import Logging
import SQLiteData

struct DiaryService {
  @Dependency(\.defaultDatabase) private var database

  /// 创建日记（可附带标签）
  func create(_ entry: MokiDiary, tags: [MokiTag] = []) {
    AppLogger.database.info("请求创建日记")
    do {
      try database.write { db in
        // 1. 创建日记
        try MokiDiary
          .insert { entry }
          .execute(db)

        // 2. 关联标签
        if !tags.isEmpty {
          try TagService.updateTags(tags, forDiary: entry.id, in: db)
        }
      }
      AppLogger.database.info("✅ 创建日记成功，关联 \(tags.count) 个标签")
    } catch {
      AppToast.show("创建失败：\(error.localizedDescription)")
    }
  }

  /// 更新日记（可同时更新标签）
  func update(_ entry: MokiDiary, tags: [MokiTag]? = nil) {
    AppLogger.database.info("请求更新日记", metadata: ["id": "\(entry.id)"])
    do {
      try database.write { db in
        // 1. 更新日记内容
        try MokiDiary
          .update {
            $0.text = entry.text
            $0.updatedAt = Date()
            $0.isStarred = entry.isStarred
          }
          .where { $0.id.eq(entry.id) }
          .execute(db)

        // 2. 更新标签关联（如果传入了标签）
        if let tags = tags {
          try TagService.updateTags(tags, forDiary: entry.id, in: db)
        }
      }
      AppLogger.database.info("✅ 更新日记成功")
    } catch {
      AppToast.show("更新失败：\(error.localizedDescription)")
    }
  }

  /// 软删除日记（可恢复）
  func delete(_ entry: MokiDiary) {
    AppLogger.database.info("软删除日记", metadata: ["id": "\(entry.id)"])
    do {
      try database.write { db in
        try MokiDiary
          .update {
            $0.deletedAt = Date()
            $0.updatedAt = Date()
          }
          .where { $0.id.eq(entry.id) }
          .execute(db)
      }
    } catch {
      AppToast.show("删除失败：\(error.localizedDescription)")
    }
  }

  /// 恢复已删除的日记
  func restore(_ entry: MokiDiary) {
    AppLogger.database.info("恢复日记", metadata: ["id": "\(entry.id)"])
    do {
      try database.write { db in
        try MokiDiary
          .update {
            $0.deletedAt = nil
            $0.updatedAt = Date()
          }
          .where { $0.id.eq(entry.id) }
          .execute(db)
      }
    } catch {
      AppToast.show("恢复失败：\(error.localizedDescription)")
    }
  }

  /// 永久删除日记（不可恢复）
  func deletePermanently(_ entry: MokiDiary) {
    AppLogger.database.info("永久删除日记", metadata: ["id": "\(entry.id)"])
    do {
      try database.write { db in
        try MokiDiary
          .delete(entry)
          .execute(db)
      }
    } catch {
      AppToast.show("删除失败：\(error.localizedDescription)")
    }
  }
}
