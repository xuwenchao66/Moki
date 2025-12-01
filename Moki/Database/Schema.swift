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
  var modifiedAt: Date?

  /// 是否标星
  var isStarred: Bool = false

  // MARK: - Init

  init(
    id: UUID = UUID(),
    text: String,
    createdAt: Date = Date(),
    isStarred: Bool = false
  ) {
    self.id = id
    self.text = text
    self.createdAt = createdAt
    self.modifiedAt = nil
    self.isStarred = isStarred
  }
}

extension MokiDiary {
  /// 内置欢迎条目，用于首次启动时填充数据库
  static var welcomeEntry: MokiDiary {
    MokiDiary(
      text: """
        # 👋 欢迎来到 Moki

        这是一个简单的开始。Moki 旨在帮助你记录生活中的闪光时刻，让回忆更有质感。

        ### 为什么叫 Moki (木几)？
        "木几" 取自 "机" 字的拆解，寓意**有机的生活**与**自然的记录**。我们希望剥离复杂的社交干扰，回归记录的本质。

        ### 你可以尝试：
        - 📝 写下你的第一篇日记
        - ⭐️ 标记重要的时刻
        - 📅 按时间轴回顾你的生活

        祝你记录愉快！
        """,
      createdAt: Date(),
      isStarred: true
    )
  }
}

// MARK: - Tags

@Table("tags")
struct MokiTag: Identifiable, Codable, Equatable, Hashable {
  /// 唯一标识符
  /// 建议使用 UUID 以保持与 Diaries 的一致性，方便 SwiftData/CoreData 迁移及离线生成 ID
  let id: UUID

  /// 标签名称 (Unique)
  var name: String

  /// 标签颜色 (Hex, 可选)
  /// 对应截图中的 TEXT 类型，存储 "#FF5733" 格式
  var color: String?

  /// 创建时间
  var createdAt: Date

  init(id: UUID = UUID(), name: String, color: String? = nil, createdAt: Date = Date()) {
    self.id = id
    self.name = name
    self.color = color
    self.createdAt = createdAt
  }
}

// MARK: - Relations

/// 日记与标签的多对多关联表
/// 使用中间表是处理 Tag 系统的最佳实践，比在 Diary 中存 String 更灵活（便于重命名、统计、筛选）
@Table("diary_tags")
struct MokiDiaryTag: Codable, Equatable, Hashable {
  /// 关联的日记 ID
  let diaryId: UUID

  /// 关联的标签 ID
  let tagId: UUID

  init(diaryId: UUID, tagId: UUID) {
    self.diaryId = diaryId
    self.tagId = tagId
  }
}
