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

  /// 删除日记
  func delete(_ entry: MokiDiary) {
    AppLogger.database.info("请求删除日记", metadata: ["id": "\(entry.id)"])
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
