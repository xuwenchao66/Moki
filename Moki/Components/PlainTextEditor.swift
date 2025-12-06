//
//  PlainTextEditor.swift
//  Moki
//
//  基于 UITextView 的可控编辑组件，支持占位符、行高、主题样式
//

import SwiftUI
import UIKit

struct PlainTextEditor: UIViewRepresentable {
  @Binding var text: String
  @Binding var isFocused: Bool
  var placeholder: String

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.delegate = context.coordinator
    textView.backgroundColor = .clear
    textView.text = text

    // 字体/颜色
    textView.font = UIFont.systemFont(ofSize: 17) // 对应 Theme.font.journalBody
    textView.textColor = UIColor(named: "foreground") ?? .label
    textView.tintColor = UIColor(named: "primaryAction") ?? .black

    // 行高
    applyParagraphStyle(to: textView)

    // 输入行为
    textView.autocapitalizationType = .none
    textView.autocorrectionType = .yes
    textView.smartDashesType = .no
    textView.smartQuotesType = .no
    textView.isScrollEnabled = true
    textView.alwaysBounceVertical = true
    textView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)

    // 占位符（兼容较低 iOS 版本，直接基于 textContainerInsets 手动布局）
    let placeholderLabel = UILabel()
    placeholderLabel.text = placeholder
    placeholderLabel.font = textView.font
    placeholderLabel.textColor = UIColor(named: "foregroundTertiary") ?? .secondaryLabel
    placeholderLabel.numberOfLines = 0
    placeholderLabel.tag = 999
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
    textView.addSubview(placeholderLabel)
    NSLayoutConstraint.activate([
      placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: textView.textContainerInset.top),
      placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: textView.textContainerInset.left + 2),
      placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -(textView.textContainerInset.right + 2))
    ])
    placeholderLabel.isHidden = !text.isEmpty

    return textView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    if uiView.text != text {
      uiView.text = text
      applyParagraphStyle(to: uiView)
    }

    // 占位符显隐
    if let placeholderLabel = uiView.viewWithTag(999) as? UILabel {
      placeholderLabel.isHidden = !text.isEmpty
    }

    // 焦点同步
    if isFocused, !uiView.isFirstResponder {
      uiView.becomeFirstResponder()
    } else if !isFocused, uiView.isFirstResponder {
      uiView.resignFirstResponder()
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  private func applyParagraphStyle(to textView: UITextView) {
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineSpacing = Theme.spacing.textLineSpacing

    // typingAttributes 影响新输入和光标
    textView.typingAttributes = [
      .font: textView.font as Any,
      .foregroundColor: textView.textColor as Any,
      .paragraphStyle: paragraph
    ]

    // 已有文本也应用行高
    if !textView.text.isEmpty {
      let attr = NSMutableAttributedString(string: textView.text)
      attr.addAttributes(textView.typingAttributes, range: NSRange(location: 0, length: attr.length))
      textView.attributedText = attr
    }
  }

  final class Coordinator: NSObject, UITextViewDelegate {
    var parent: PlainTextEditor
    init(_ parent: PlainTextEditor) { self.parent = parent }

    func textViewDidChange(_ textView: UITextView) {
      parent.text = textView.text
      if let placeholderLabel = textView.viewWithTag(999) as? UILabel {
        placeholderLabel.isHidden = !textView.text.isEmpty
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

