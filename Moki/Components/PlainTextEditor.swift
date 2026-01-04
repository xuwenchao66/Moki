import SwiftUI
import UIKit

// MARK: - Custom UITextView with Full Menu Support

private class FullMenuTextView: UITextView {
  /// 确保所有标准编辑菜单项都可用（剪切、拷贝、粘贴、全选等）
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    // 全选：始终可用
    if action == #selector(selectAll(_:)) {
      return true
    }

    // 剪切/拷贝：有选中文本时可用
    if action == #selector(cut(_:)) || action == #selector(copy(_:)) {
      return selectedRange.length > 0
    }

    // 粘贴：剪贴板有内容时可用
    if action == #selector(paste(_:)) {
      return UIPasteboard.general.hasStrings
    }

    // 其他操作由系统决定
    return super.canPerformAction(action, withSender: sender)
  }
}

struct PlainTextEditor: UIViewRepresentable {
  @Binding var text: String
  @Binding var isFocused: Bool
  var placeholder: String

  // MARK: - Constants

  private enum Constants {
    static let placeholderTag = 999
    // 移除内部内边距，完全由外部 SwiftUI padding 控制
    static let horizontalInset: CGFloat = 0
    static let verticalInset: CGFloat = 0
    static let placeholderLeadingOffset: CGFloat = 0
  }

  // MARK: - UIViewRepresentable

  func makeUIView(context: Context) -> UITextView {
    let textView = FullMenuTextView()
    textView.delegate = context.coordinator
    textView.backgroundColor = .clear
    textView.text = text

    // 字体/颜色 - 使用 JournalBodyStyle 统一样式
    textView.font = Theme.font.journalBodyUIFont

    // 从 Theme.color.foreground 获取颜色（适配深色模式）
    textView.textColor = UIColor(Theme.color.foreground)
    // 光标使用黑色（与 Anthropic CTA 一致）
    textView.tintColor = UIColor(Theme.color.foreground)

    // 输入行为（适合日记场景）
    textView.autocapitalizationType = .sentences  // 句首字母大写
    textView.autocorrectionType = .yes
    textView.isScrollEnabled = true
    textView.alwaysBounceVertical = true

    // 移除所有内部边距，以便外部精准控制对齐
    textView.textContainerInset = .zero
    textView.textContainer.lineFragmentPadding = 0

    // 占位符
    setupPlaceholder(in: textView)

    // 初始样式
    applyParagraphStyle(to: textView)

    return textView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    let needsTextUpdate = uiView.text != text

    if needsTextUpdate {
      uiView.text = text
      // 只在非输入法状态下更新样式，避免打断中文输入
      if uiView.markedTextRange == nil {
        applyParagraphStyle(to: uiView)
      }
    }

    // 占位符显隐
    updatePlaceholder(in: uiView)

    // 焦点同步
    syncFocus(with: uiView)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  // MARK: - Private Helpers

  private func setupPlaceholder(in textView: UITextView) {
    let placeholderLabel = UILabel()
    placeholderLabel.text = placeholder
    placeholderLabel.font = Theme.font.journalBodyUIFont
    placeholderLabel.textColor = UIColor(Theme.color.mutedForeground)
    placeholderLabel.numberOfLines = 0
    placeholderLabel.tag = Constants.placeholderTag
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
    textView.addSubview(placeholderLabel)

    NSLayoutConstraint.activate([
      placeholderLabel.topAnchor.constraint(
        equalTo: textView.topAnchor,
        constant: textView.textContainerInset.top
      ),
      placeholderLabel.leadingAnchor.constraint(
        equalTo: textView.leadingAnchor,
        constant: textView.textContainerInset.left + Constants.placeholderLeadingOffset
      ),
      placeholderLabel.trailingAnchor.constraint(
        equalTo: textView.trailingAnchor,
        constant: -(textView.textContainerInset.right + Constants.placeholderLeadingOffset)
      ),
    ])

    placeholderLabel.isHidden = !text.isEmpty
  }

  private func placeholder(in textView: UITextView) -> UILabel? {
    textView.viewWithTag(Constants.placeholderTag) as? UILabel
  }

  private func updatePlaceholder(in textView: UITextView) {
    placeholder(in: textView)?.isHidden = !text.isEmpty
  }

  private func syncFocus(with textView: UITextView) {
    if isFocused, !textView.isFirstResponder {
      textView.becomeFirstResponder()
    } else if !isFocused, textView.isFirstResponder {
      textView.resignFirstResponder()
    }
  }

  private func applyParagraphStyle(to textView: UITextView) {
    let font = Theme.font.journalBodyUIFont

    let paragraph = NSMutableParagraphStyle()
    // 空文本时不设置 lineSpacing，光标保持字体默认高度
    // 有文本时再应用行间距（使用 JournalBodyStyle 统一的行间距）
    paragraph.lineSpacing = textView.text.isEmpty ? 0 : Theme.font.journalBodyLineSpacing

    // typingAttributes 影响新输入和光标
    // 包含 kerning 字间距，与 JournalBodyStyle 保持一致
    textView.typingAttributes = [
      .font: font,
      .foregroundColor: textView.textColor as Any,
      .paragraphStyle: paragraph,
      .kern: Theme.font.journalBodyKerning,
    ]

    // 已有文本也应用样式
    if !textView.text.isEmpty {
      let attr = NSMutableAttributedString(string: textView.text)
      attr.addAttributes(
        textView.typingAttributes,
        range: NSRange(location: 0, length: attr.length)
      )
      textView.attributedText = attr
    }
  }

  // MARK: - Coordinator

  final class Coordinator: NSObject, UITextViewDelegate {
    var parent: PlainTextEditor

    init(_ parent: PlainTextEditor) {
      self.parent = parent
    }

    func textViewDidChange(_ textView: UITextView) {
      parent.text = textView.text
      parent.updatePlaceholder(in: textView)

      // 文本变化时重新应用样式（空/非空切换时更新光标高度）
      // 只在非输入法状态下更新，避免打断中文输入
      if textView.markedTextRange == nil {
        parent.applyParagraphStyle(to: textView)
      }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
      parent.isFocused = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
      parent.isFocused = false
    }
  }
}
