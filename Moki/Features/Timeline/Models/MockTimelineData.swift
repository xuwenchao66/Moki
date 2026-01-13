//
//  MockTimelineData.swift
//  Moki
//
//  Timeline 功能的测试数据
//

import Foundation

// 临时 Mock 数据模型
struct MockEntry: Identifiable {
  let id = UUID()
  let content: String
  let date: Date
  let images: [String]
  let tags: [String]
}

extension MockEntry {
  // 硬编码的演示数据
  static var examples: [MockEntry] {
    let now = Date()
    let calendar = Calendar.current

    // 辅助函数：生成指定时间的 Date 对象
    // monthOffset: 0 是当月, -1 是上个月
    // day: 具体几号 (如果为 0 或负数则基于当前日期偏移，这里为了方便 Mock 直接指定 day 会更直观，或者保持 offset)
    // 为了方便构造多月数据，这里改为指定 monthOffset 和 dayOffset
    func time(_ monthOffset: Int, _ dayOffset: Int, _ hour: Int, _ minute: Int) -> Date {
      // 先偏移月份
      guard let monthDate = calendar.date(byAdding: .month, value: monthOffset, to: now) else {
        return now
      }

      // 再偏移天数 (基于 monthDate)
      // 为了简单，这里 dayOffset 0 表示 monthDate 当天。
      // 如果想要固定日期，稍微复杂点。
      // 我们假设 dayOffset 是相对于 monthDate 的偏移。
      guard let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: monthDate) else {
        return monthDate
      }

      return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: dayDate) ?? dayDate
    }

    return [
      // MARK: - 本月数据 (0)
      MockEntry(
        content: "欲望是你跟自己签的协议：在得到你想要的东西之前，你一直不会快乐。",
        date: time(0, 0, 23, 42),
        images: [],
        tags: ["Naval", "智慧"]
      ),
      MockEntry(
        content: "下班路上的光影，治愈了一整天的疲惫。",
        date: time(0, 0, 20, 15),
        images: ["1"],
        tags: ["摄影"]
      ),
      MockEntry(
        content: "趁着午休时间去公园走了走，秋天真的太美了。\n\n阳光透过树叶洒下来，像是给地面铺了一层金箔。空气里有桂花的香味，深呼吸，感觉肺都被净化了。",
        date: time(0, 0, 12, 30),
        images: ["1", "2"],
        tags: []
      ),
      MockEntry(
        content: "早安 Moki",
        date: time(0, 0, 08, 00),
        images: [],
        tags: ["早安"]
      ),
      MockEntry(
        content: "昨天的记录，测试时间线分组功能。",
        date: time(0, -1, 22, 00),
        images: [],
        tags: ["测试"]
      ),

      // MARK: - 上个月数据 (-1)
      MockEntry(
        content: "上个月的总结：\n1. 完成了 Moki 的基础架构\n2. 读完了两本书\n3. 坚持跑步 50 公里\n继续加油！",
        date: time(-1, 0, 21, 30),
        images: [],
        tags: ["复盘", "总结"]
      ),
      MockEntry(
        content: "周末去了一趟海边，虽然风很大，但是心情很放松。",
        date: time(-1, -2, 14, 20),
        images: ["1"],  // 假设复用图片
        tags: ["旅行", "生活"]
      ),
      MockEntry(
        content: "遇到一个棘手的 Bug，排查了一整天，最后发现是拼写错误... 程序员的日常。",
        date: time(-1, -5, 18, 45),
        images: [],
        tags: ["开发", "吐槽"]
      ),

      // MARK: - 两个月前数据 (-2)
      MockEntry(
        content: "开始构思 Moki 的设计风格，想要一种极致的简约感，像 Claude 一样优雅。",
        date: time(-2, 0, 10, 15),
        images: [],
        tags: ["设计", "灵感"]
      ),
      MockEntry(
        content: "很久没有像今天这样睡个懒觉了，醒来已经是中午。",
        date: time(-2, -1, 11, 00),
        images: [],
        tags: ["日常"]
      ),
      MockEntry(
        content: "读《纳瓦尔宝典》，非常有启发的一句话：\n'幸福是一种技能，就像营养学和饮食一样。'",
        date: time(-2, -3, 22, 10),
        images: ["2"],
        tags: ["阅读", "摘录"]
      ),

      // MARK: - 去年数据 (2024)
      MockEntry(
        content: "再见 2024。这一年发生了很多事，开始做独立开发，开始认真记录生活。希望明年会更好。",
        date: time(-12, 0, 23, 59),
        images: ["1"],
        tags: ["年度总结"]
      ),
      MockEntry(
        content: "翻到了去年的老照片，那时候头发还很短。",
        date: time(-15, 0, 14, 20),
        images: ["2"],
        tags: ["回忆"]
      ),
    ]
  }
}
