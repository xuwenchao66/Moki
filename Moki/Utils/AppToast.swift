//
//  AppToast.swift
//  Moki
//
//  全局 Toast 封装，统一管理提示样式与调用方式
//

import UIKit

#if canImport(Toast_Swift)
  import Toast_Swift
#elseif canImport(Toast)
  import Toast
#endif

enum AppToast {
  /// 统一的 Toast 展示入口
  static func show(
    _ message: String,
    duration: TimeInterval = 2.0,
    position: ToastPosition = .top
  ) {
    guard
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let window = windowScene.windows.first(where: { $0.isKeyWindow })
    else {
      return
    }

    window.makeToast(message, duration: duration, position: position)
  }
}
