//
//  TagService.swift
//  Moki
//
//  标签相关的数据库操作
//

import Foundation
import SQLiteData

@MainActor
final class TagService {
  private let database: DatabaseWriter

  init(database: DatabaseWriter = AppDatabase.shared.writer) {
    self.database = database
  }

  // MARK: - 查询

  /// 获取所有标签（按名称排序）
  func fetchAllTags() -> [MokiTag] {
    do {
      return try database.read {
        try MokiTag
          .order { $0.name.asc() }
          .fetchAll($0)
      }
    } catch {
      print("❌ 获取标签失败: \(error)")
      return []
    }
  }

  /// 获取某个日记的所有标签（按 order 排序）
  func fetchTags(forDiary diaryId: UUID) -> [MokiTag] {
    do {
      return try database.read { db in
        // 1. 查询关联关系
        let associations =
          try MokiDiaryTag
          .filter { $0.diaryId == diaryId }
          .order { $0.order.asc() }
          .fetchAll(db)

        // 2. 获取标签 ID 列表
        let tagIds = associations.map(\.tagId)

        // 3. 查询标签详情
        return
          try MokiTag
          .filter { $0.id.in(tagIds) }
          .fetchAll(db)
      }
    } catch {
      print("❌ 获取日记标签失败: \(error)")
      return []
    }
  }

  /// 根据名称搜索标签
  func searchTags(query: String) -> [MokiTag] {
    guard !query.isEmpty else { return fetchAllTags() }

    do {
      return try database.read {
        try MokiTag
          .filter { $0.name.like("%\(query)%") }
          .order { $0.name.asc() }
          .fetchAll($0)
      }
    } catch {
      print("❌ 搜索标签失败: \(error)")
      return []
    }
  }

  // MARK: - 创建

  /// 创建新标签（自动去重）
  func createTag(name: String, color: String? = nil) -> MokiTag? {
    let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

    guard !trimmedName.isEmpty else {
      print("⚠️ 标签名称不能为空")
      return nil
    }

    do {
      return try database.write { db in
        // 检查是否已存在
        if let existing =
          try MokiTag
          .filter { $0.name == trimmedName }
          .fetchOne(db)
        {
          // 标签已存在，直接返回
          print("ℹ️ 标签已存在: \(trimmedName)")
          return existing
        }

        // 创建新标签
        let tag = MokiTag(name: trimmedName, color: color)
        try tag.insert(db)
        return tag
      }
    } catch {
      print("❌ 创建标签失败: \(error)")
      return nil
    }
  }

  // MARK: - 更新

  /// 更新标签信息
  func updateTag(_ tag: MokiTag) {
    do {
      try database.write { db in
        var updated = tag
        updated.updatedAt = Date()
        try updated.update(db)
      }
    } catch {
      print("❌ 更新标签失败: \(error)")
    }
  }

  /// 重命名标签（会检查名称冲突）
  func renameTag(_ tag: MokiTag, newName: String) -> Bool {
    let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)

    guard !trimmedName.isEmpty else {
      print("⚠️ 标签名称不能为空")
      return false
    }

    do {
      return try database.write { db in
        // 检查新名称是否已被使用
        if let _ =
          try MokiTag
          .filter { $0.name == trimmedName && $0.id != tag.id }
          .fetchOne(db)
        {
          print("⚠️ 标签名称已存在: \(trimmedName)")
          return false
        }

        // 更新名称
        var updated = tag
        updated.name = trimmedName
        updated.updatedAt = Date()
        try updated.update(db)
        return true
      }
    } catch {
      print("❌ 重命名标签失败: \(error)")
      return false
    }
  }

  // MARK: - 删除

  /// 删除标签（级联删除所有关联）
  func deleteTag(_ tag: MokiTag) {
    do {
      try database.write { db in
        try tag.delete(db)  // 外键 CASCADE 会自动删除 diary_tags 关联
      }
    } catch {
      print("❌ 删除标签失败: \(error)")
    }
  }

  // MARK: - 关联管理

  /// 给日记添加标签
  func addTag(_ tagId: UUID, toDiary diaryId: UUID) {
    do {
      try database.write { db in
        // 检查是否已关联
        let exists =
          try MokiDiaryTag
          .filter { $0.diaryId == diaryId && $0.tagId == tagId }
          .fetchOne(db) != nil

        guard !exists else {
          print("⚠️ 标签已关联到该日记")
          return
        }

        // 获取当前最大 order
        let maxOrder =
          try MokiDiaryTag
          .filter { $0.diaryId == diaryId }
          .max { $0.order }
          .fetchOne(db)?
          .order ?? -1

        // 添加关联
        let association = MokiDiaryTag(
          diaryId: diaryId,
          tagId: tagId,
          order: maxOrder + 1
        )
        try association.insert(db)
      }
    } catch {
      print("❌ 添加标签关联失败: \(error)")
    }
  }

  /// 从日记移除标签
  func removeTag(_ tagId: UUID, fromDiary diaryId: UUID) {
    do {
      try database.write { db in
        try MokiDiaryTag
          .filter { $0.diaryId == diaryId && $0.tagId == tagId }
          .deleteAll(db)
      }
    } catch {
      print("❌ 移除标签关联失败: \(error)")
    }
  }

  /// 更新日记的标签列表（批量操作）
  func updateTags(_ tagIds: [UUID], forDiary diaryId: UUID) {
    do {
      try database.write { db in
        // 1. 删除所有现有关联
        try MokiDiaryTag
          .filter { $0.diaryId == diaryId }
          .deleteAll(db)

        // 2. 添加新关联（按顺序）
        for (index, tagId) in tagIds.enumerated() {
          let association = MokiDiaryTag(
            diaryId: diaryId,
            tagId: tagId,
            order: index
          )
          try association.insert(db)
        }
      }
    } catch {
      print("❌ 更新日记标签失败: \(error)")
    }
  }

  // MARK: - 统计

  /// 获取标签使用次数（降序排列）
  func fetchTagUsageStats() -> [(tag: MokiTag, count: Int)] {
    do {
      return try database.read { db in
        // 1. 统计每个标签的使用次数
        let associations =
          try MokiDiaryTag
          .order { $0.tagId.asc() }
          .fetchAll(db)

        let counts = Dictionary(
          grouping: associations,
          by: { $0.tagId }
        )
        .mapValues { $0.count }

        // 2. 获取标签详情
        let tags =
          try MokiTag
          .fetchAll(db)

        // 3. 组合数据并排序
        return
          tags
          .map { (tag: $0, count: counts[$0.id] ?? 0) }
          .sorted { $0.count > $1.count }
      }
    } catch {
      print("❌ 获取标签统计失败: \(error)")
      return []
    }
  }
}
