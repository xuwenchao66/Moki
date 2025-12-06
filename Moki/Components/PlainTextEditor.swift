//
//  PlainTextEditor.swift
//  Moki
//
//  基于 UITextView 的可控编辑组件，支持占位符、行高、主题样式
//

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
    static let fontSize: CGFloat = 17
    static let placeholderTag = 999
    static let horizontalInset: CGFloat = 5
    static let verticalInset: CGFloat = 8
    static let placeholderLeadingOffset: CGFloat = 6
  }

  // MARK: - UIViewRepresentable

  func makeUIView(context: Context) -> UITextView {
    let textView = FullMenuTextView()
    textView.delegate = context.coordinator
    textView.backgroundColor = .clear
    textView.text = text

    // 字体/颜色
    textView.font = UIFont.systemFont(ofSize: Constants.fontSize)
    textView.textColor = UIColor(named: "foreground") ?? .label
    textView.tintColor = UIColor(named: "primaryAction") ?? .black

    // 输入行为（适合日记场景）
    textView.autocapitalizationType = .sentences  // 句首字母大写
    textView.autocorrectionType = .yes
    textView.isScrollEnabled = true
    textView.alwaysBounceVertical = true
    textView.textContainerInset = UIEdgeInsets(
      top: Constants.verticalInset,
      left: Constants.horizontalInset,
      bottom: Constants.verticalInset,
      right: Constants.horizontalInset
    )

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
    placeholderLabel.font = textView.font
    placeholderLabel.textColor = UIColor(named: "foregroundTertiary") ?? .secondaryLabel
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
    guard let font = textView.font else { return }

    let paragraph = NSMutableParagraphStyle()
    // 空文本时不设置 lineSpacing，光标保持字体默认高度
    // 有文本时再应用行间距
    paragraph.lineSpacing = textView.text.isEmpty ? 0 : Theme.spacing.textLineSpacing

    // typingAttributes 影响新输入和光标
    textView.typingAttributes = [
      .font: font,
      .foregroundColor: textView.textColor as Any,
      .paragraphStyle: paragraph,
    ]

    // 已有文本也应用行高
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
