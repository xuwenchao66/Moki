//
//  PreviewData.swift
//  Moki
//
//  预览和测试数据
//

import Foundation

extension JournalEntry {

  /// 模拟数据
  static var mockEntries: [JournalEntry] {
    return [
      JournalEntry(
        text: "欲望是你跟自己签的协议：在得到你想要的东西之前，你一直不会快乐。",
        createdAt: Date().addingTimeInterval(-86400 * 2)  // 2天前
      ),
      JournalEntry(
        text: "对行动要有急迫感，对结果要有耐心。",
        createdAt: Date().addingTimeInterval(-86400)  // 1天前
      ),
      JournalEntry(
        text: "幸福是一种技能，就像健身和赚钱一样。",
        createdAt: Date()
      ),
    ]
  }
}
