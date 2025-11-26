//
//  Persistence.swift
//  Moki
//
//  供 SwiftUI Preview / 单元测试复用的内存数据库
//

import Foundation
import SQLiteData

enum Persistence {
  static let preview: DatabaseQueue = {
    do {
      let database = try AppDatabase.makeInMemoryWriter()
      try seedPreviewData(database)
      return database
    } catch {
      fatalError("无法创建 Preview 数据库: \(error)")
    }
  }()

  static func makePreviewDatabase() -> DatabaseQueue {
    do {
      let database = try AppDatabase.makeInMemoryWriter()
      try seedPreviewData(database)
      return database
    } catch {
      fatalError("无法创建 Preview 数据库: \(error)")
    }
  }

  private static func seedPreviewData(_ database: DatabaseWriter) throws {
    try database.write { db in
      let count = try JournalEntry.count().fetchOne(db) ?? 0
      guard count == 0 else { return }

      for entry in JournalEntry.mockEntries {
        try #sql(
          """
          INSERT INTO "diaries" ("id", "text", "createdAt", "modifiedAt", "isStarred")
          VALUES (
            \(entry.id.uuidString),
            \(entry.text),
            \(entry.createdAt),
            \(entry.modifiedAt),
            \(entry.isStarred)
          )
          """
        )
        .execute(db)
      }
    }
  }
}

