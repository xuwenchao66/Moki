//
//  TagCapsule.swift
//  Moki
//
//  标签胶囊组件
//  风格：灰色文字 #tag
//

import SwiftUI

/// 标签胶囊组件
struct TagCapsule: View {
  let text: String
  let color: Color

  init(_ text: String, color: Color = Theme.color.tagText) {
    self.text = text
    self.color = color
  }

  var body: some View {
    Text("#\(text)")
      .font(Theme.font.tag)
      .foregroundColor(color)
  }
}

// MARK: - Tag Flow Layout (标签流式布局)

/// 标签流式布局容器
struct TagFlowLayout: View {
  let tags: [String]
  var spacing: CGFloat = Theme.spacing.xs

  init(
    tags: [String],
    spacing: CGFloat = Theme.spacing.xs
  ) {
    self.tags = tags
    self.spacing = spacing
  }

  var body: some View {
    FlowLayout(spacing: spacing) {
      ForEach(Array(tags.enumerated()), id: \.offset) { index, tag in
        TagCapsule(tag)
      }
    }
  }
}

/// 简易流式布局
struct FlowLayout: Layout {
  var spacing: CGFloat = Theme.spacing.xs  // 默认 8

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let result = FlowResult(
      in: proposal.replacingUnspecifiedDimensions().width,
      subviews: subviews,
      spacing: spacing
    )
    return result.size
  }

  func placeSubviews(
    in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
  ) {
    let result = FlowResult(
      in: bounds.width,
      subviews: subviews,
      spacing: spacing
    )
    for (index, subview) in subviews.enumerated() {
      subview.place(at: result.positions[index], proposal: .unspecified)
    }
  }

  struct FlowResult {
    var size: CGSize = .zero
    var positions: [CGPoint] = []

    init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
      var x: CGFloat = 0
      var y: CGFloat = 0
      var lineHeight: CGFloat = 0

      for subview in subviews {
        let size = subview.sizeThatFits(.unspecified)

        if x + size.width > maxWidth && x > 0 {
          x = 0
          y += lineHeight + spacing
          lineHeight = 0
        }

        positions.append(CGPoint(x: x, y: y))
        lineHeight = max(lineHeight, size.height)
        x += size.width + spacing
      }

      self.size = CGSize(width: maxWidth, height: y + lineHeight)
    }
  }
}

// MARK: - Preview

#Preview("标签样式预览") {
  VStack(alignment: .leading, spacing: Theme.spacing.xl) {
    Text("标签样式")
      .titleStyle()

    TagFlowLayout(
      tags: ["Naval", "幸福", "成长", "学习", "智慧", "生活", "思考"]
    )
    .padding()
    .background(Color.white)
    .cornerRadius(Theme.radius.sm)  // 8
  }
  .padding(Theme.spacing.lg)
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Theme.color.background)
}
