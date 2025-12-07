import Dependencies
import Foundation
import SQLiteData

struct DiaryService {
  @Dependency(\.defaultDatabase) private var database

  func delete(_ entry: MokiDiary) {
    print("Request delete for entry: \(entry.id)")
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
