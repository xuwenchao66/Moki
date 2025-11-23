//
//  PreviewData.swift
//  Moki
//
//  预览数据 - 用于 SwiftUI Preview
//

import Foundation

/// Mock 日记数据
struct MockJournalData {
  static let sampleEntries = [
    (
      content: "欲望是你跟自己签的协议：在得到你想要的东西之前，你一直不会快乐。",
      time: "23:42:15",
      tags: ["Naval", "幸福"]
    ),
    (
      content: "对行动要有急迫感，对结果要有耐心。",
      time: "15:20:08",
      tags: ["Naval", "智慧"]
    ),
    (
      content: "幸福是一种技能，就像健身和赚钱一样。",
      time: "11:05:33",
      tags: ["Naval", "成长"]
    ),
    (
      content: "阅读比听更有效率。做比看更有效率。",
      time: "19:15:42",
      tags: ["Naval", "学习"]
    ),
  ]

  static let allTags = ["Naval", "幸福", "智慧", "成长", "学习", "思考", "生活", "工作"]
}
