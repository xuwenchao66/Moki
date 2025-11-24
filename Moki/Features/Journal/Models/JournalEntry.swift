//
//  JournalEntry.swift
//  Moki
//
//  日记核心模型 (基于 sqlite-data)
//

import Foundation
// import SQLiteData // 暂时注释，假设你已经添加了依赖
import SwiftUI

// 注意：你需要确保项目中已添加 PointFree 的 SQLiteData 依赖
// @Table("journal_entries")
// 暂时使用普通 struct 模拟，等你集成好 sqlite-data 后取消注释 @Table 即可
struct JournalEntry: Identifiable, Codable, Equatable, Hashable {

  /// 唯一标识符 (对应 Day One 的 UUID)
  let id: UUID

  /// 日记正文 (必填)
  var text: String

  /// 创建时间
  var createdAt: Date

  /// 修改时间
  var modifiedAt: Date?

  /// 是否标星/收藏
  var isStarred: Bool

  /// 标签列表
  var tags: [String]

  /// 图片元数据映射
  /// 用于解析 text 中的 ![](dayone-moment://ID)
  var photos: [EntryPhoto]

  // MARK: - Init

  init(
    id: UUID = UUID(),
    text: String,
    createdAt: Date = Date(),
    tags: [String] = [],
    photos: [EntryPhoto] = [],
    isStarred: Bool = false
  ) {
    self.id = id
    self.text = text
    self.createdAt = createdAt
    self.modifiedAt = nil
    self.tags = tags
    self.photos = photos
    self.isStarred = isStarred
  }
}

/// 图片元数据
struct EntryPhoto: Codable, Equatable, Hashable, Identifiable {
  var id: String { identifier }

  /// Day One 的图片唯一标识 (Markdown 中引用的 ID)
  let identifier: String

  /// 图片文件名 (如 IMG_123.JPG)
  let filename: String

  /// 图片宽度
  let width: Int

  /// 图片高度
  let height: Int
}
