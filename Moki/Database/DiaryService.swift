import Dependencies
import Foundation
import SQLiteData

struct DiaryService {
  @Dependency(\.defaultDatabase) private var database

  func create(_ entry: MokiDiary) {
    debugPrint("Request create diary")
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
    debugPrint("Request update diary: \(entry.id)")
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
    debugPrint("Request delete for entry: \(entry.id)")
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
