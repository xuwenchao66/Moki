//
//  JournalDateHeader.swift
//  Moki
//
//  日记时间轴的日期头
//  格式：胶囊状日期背景 + 右侧分割线
//

import SwiftUI

struct JournalDateHeader: View {
  let date: String

  var body: some View {
    HStack {
      Text(date)
        .font(Theme.font.tag.weight(.semibold))
        .foregroundColor(Theme.color.accentDarkText)
        .padding(.horizontal, Theme.spacing.sm)  // 12
        .padding(.vertical, Theme.spacing.compact)  // 6
        .background(Theme.color.accentLightBackground)
        .clipShape(Capsule())

      // 右侧分割线
      Rectangle()
        .fill(Theme.color.border)
        .frame(height: 1)

      Spacer()
    }
    .padding(.bottom, Theme.spacing.md)
  }
}

#Preview {
  JournalDateHeader(date: "2025-11-23")
    .padding()
}
