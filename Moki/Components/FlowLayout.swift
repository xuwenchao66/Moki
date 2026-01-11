//
//  FlowLayout.swift
//  Moki
//
//  流式布局组件
//  子视图从左到右排列，放不下时自动换行
//
//  ⚠️ 兼容性说明：
//  - iOS 18+ 原生支持 FlowLayout，届时可直接使用系统 API
//  - 当前为兼容 iOS 17 的自定义实现
//  - 未来最低版本升级到 iOS 18 后，可删除此文件
//

import SwiftUI

struct FlowLayout: Layout {
  var spacing: CGFloat = 8

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
    let result = layout(in: proposal.width ?? 0, subviews: subviews)
    return CGSize(width: proposal.width ?? 0, height: result.height)
  }

  func placeSubviews(
    in bounds: CGRect, proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()
  ) {
    let result = layout(in: bounds.width, subviews: subviews)

    for (index, frame) in result.frames.enumerated() {
      subviews[index].place(
        at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
        proposal: ProposedViewSize(frame.size)
      )
    }
  }

  private func layout(in width: CGFloat, subviews: Subviews) -> (frames: [CGRect], height: CGFloat)
  {
    var frames: [CGRect] = []
    var currentX: CGFloat = 0
    var currentY: CGFloat = 0
    var lineHeight: CGFloat = 0

    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)

      if currentX + size.width > width, currentX > 0 {
        currentX = 0
        currentY += lineHeight + spacing
        lineHeight = 0
      }

      frames.append(CGRect(origin: CGPoint(x: currentX, y: currentY), size: size))

      currentX += size.width + spacing
      lineHeight = max(lineHeight, size.height)
    }

    return (frames, currentY + lineHeight)
  }
}
