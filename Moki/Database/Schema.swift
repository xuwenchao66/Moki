import Foundation
import SQLiteData
import SwiftUI

@Table("diaries")
struct MokiDiary: Identifiable, Codable, Equatable, Hashable {

  /// 唯一标识符
  let id: UUID

  /// 日记正文 (必填)
  var text: String

  /// 创建时间
  var createdAt: Date

  /// 修改时间
  var updatedAt: Date?

  /// 软删除时间戳
  /// nil = 未删除，有值 = 已删除（可恢复）
  var deletedAt: Date?

  /// 是否标星
  var isStarred: Bool = false

  /// 时区 (例如 "Asia/Shanghai")
  /// 用于记录日记创建时的时区，确保在不同时区查看时能还原"当时"的时间感
  var timeZone: String

  /// JSON 扩展字段
  /// 用于存储额外数据，不需要频繁修改表结构
  /// 示例: {"mood": "happy", "weather": "sunny", "location": "home"}
  var metadata: String = "{}"

  // MARK: - Init

  init(
    id: UUID = UUID(),
    text: String,
    createdAt: Date = Date(),
    deletedAt: Date? = nil,
    isStarred: Bool = false,
    timeZone: String = TimeZone.current.identifier,
    metadata: String = "{}"
  ) {
    self.id = id
    self.text = text
    self.createdAt = createdAt
    self.updatedAt = nil
    self.deletedAt = deletedAt
    self.isStarred = isStarred
    self.timeZone = timeZone
    self.metadata = metadata
  }
}

// MARK: - Tags

@Table("tags")
struct MokiTag: Identifiable, Codable, Equatable, Hashable {
  /// 唯一标识符
  let id: UUID

  /// 标签名称 (Unique - 在数据库层面保证唯一性)
  var name: String

  /// 标签颜色 (Hex, 可选)
  /// 存储格式: "#FF5733"
  var color: String?

  /// 排序
  /// 用于标签列表排序，值越小越靠前
  var order: Int

  /// 创建时间
  var createdAt: Date

  /// 修改时间
  var updatedAt: Date?

  /// JSON 扩展字段
  /// 用于存储标签的展示配置和扩展属性
  ///
  /// 普通标签示例: {"icon": "🏖️"}
  ///
  /// 书籍形态标签示例: {
  ///   "displayMode": "book",              // 展示模式：book(书籍) / tag(标签)
  ///   "coverImage": "travel_2024.jpg",    // 封面图片（本地文件名或 URL）
  ///   "coverColor": "#4A90E2",            // 封面背景色
  ///   "description": "2024年的旅行记录"    // 书籍描述
  /// }
  var metadata: String = "{}"

  init(
    id: UUID = UUID(),
    name: String,
    color: String? = nil,
    order: Int = 0,
    createdAt: Date = Date(),
    metadata: String = "{}"
  ) {
    self.id = id
    self.name = name
    self.color = color
    self.order = order
    self.createdAt = createdAt
    self.updatedAt = nil
    self.metadata = metadata
  }
}

// MARK: - Relations

/// 日记与标签的多对多关联表
/// 复合主键 (diaryId, tagId) 防止重复关联
/// 外键约束保证数据完整性，级联删除避免孤儿记录
@Table("diary_tags")
struct MokiDiaryTag: Codable, Equatable, Hashable {
  /// 关联的日记 ID (带索引)
  let diaryId: UUID

  /// 关联的标签 ID (带索引)
  let tagId: UUID

  /// 标签显示顺序
  /// 用于用户自定义排序，值越小越靠前，默认按创建时间排序
  var order: Int

  /// 关联创建时间
  /// 记录"何时给日记添加了这个标签"
  var createdAt: Date

  init(diaryId: UUID, tagId: UUID, order: Int = 0, createdAt: Date = Date()) {
    self.diaryId = diaryId
    self.tagId = tagId
    self.order = order
    self.createdAt = createdAt
  }
}

// MARK: - DTOs (View Models)

/// 日记 + 关联标签的聚合数据
/// 用于 UI 层展示，避免在 View 中进行数据拼接
struct DiaryWithTags: Identifiable, Equatable {
  let diary: MokiDiary
  let tags: [MokiTag]

  var id: UUID { diary.id }
}
