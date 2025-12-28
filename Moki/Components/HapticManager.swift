import SwiftUI

class HapticManager {
  static let shared = HapticManager()

  // 1. 轻触 (用于普通按钮、菜单)
  func light() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.prepare()  // 预加载，减少延迟
    generator.impactOccurred()
  }

  // 2. 扎实 (用于核心操作，如写日记)
  func medium() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.prepare()
    generator.impactOccurred()
  }

  // 3. 滚轮感 (用于滑动经过日期)
  func selection() {
    let generator = UISelectionFeedbackGenerator()
    generator.prepare()
    generator.selectionChanged()
  }
}
