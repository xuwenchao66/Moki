//
//  PreviewData.swift
//  Moki
//
//  预览和测试数据
//

import Foundation

extension JournalEntry {

  /// 欢迎日记示例
  static var welcomeEntry: JournalEntry {
    JournalEntry(
      text: """
        # 👋 欢迎来到 Moki

        这是一个简单的开始。Moki 旨在帮助你记录生活中的闪光时刻，让回忆更有质感。

        ### 为什么叫 Moki (木几)？
        "木几" 取自 "机" 字的拆解，寓意**有机的生活**与**自然的记录**。我们希望剥离复杂的社交干扰，回归记录的本质。

        ### 你可以尝试：
        - 📸 导入你之前的 **Day One** 数据
        - 🏷 使用标签整理思绪，如 #生活 #灵感
        - ☁️ 数据完全存储在你的 iCloud 中，安全且私密

        祝你记录愉快！
        """,
      createdAt: Date(),
      tags: ["Moki", "欢迎", "开始"],
      photos: [],
      isStarred: true
    )
  }

  /// 模拟导入的 Day One 数据 (基于你提供的 JSON)
  static var mockDayOneImport: [JournalEntry] {
    return [
      JournalEntry(
        text: """
          # 回到过去
          ww

          (此处假装有图片显示，ID: 8EEFA633...)
          """,
        createdAt: ISO8601DateFormatter().date(from: "2024-09-27T05:57:39Z") ?? Date(),
        tags: [],
        photos: [
          EntryPhoto(
            identifier: "8EEFA6330F124A44B5C87BFF847C8BF6", filename: "IMG_1742.PNG", width: 1179,
            height: 1922)
        ],
        isStarred: false
      ),
      JournalEntry(
        text: "纯文本测试！",
        createdAt: ISO8601DateFormatter().date(from: "2025-11-24T04:00:00Z") ?? Date(),
        tags: [],
        photos: [],
        isStarred: false
      ),
    ]
  }
}
