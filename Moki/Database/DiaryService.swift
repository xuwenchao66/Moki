import Dependencies
import Foundation
import Logging
import SQLiteData

struct DiaryService {
  @Dependency(\.defaultDatabase) private var database

  func create(_ entry: MokiDiary) {
    AppLogger.database.info("请求创建日记")
    do {
      try database.write { db in
        try MokiDiary
          .insert { entry }
          .execute(db)
      }
    } catch {
      AppToast.show("创建失败：\(error.localizedDescription)")
    }
  }

  func update(_ entry: MokiDiary) {
    AppLogger.database.info("请求更新日记", metadata: ["id": "\(entry.id)"])
    do {
      try database.write { db in
        try MokiDiary
          .update {
            $0.text = entry.text
            $0.updatedAt = Date()
            $0.isStarred = entry.isStarred
          }
          .where { $0.id.eq(entry.id) }
          .execute(db)
      }
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
