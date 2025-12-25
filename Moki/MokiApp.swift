//
//  MokiApp.swift
//  Moki
//
//  Created by xuwecnhao on 11/23/25.
//

import Dependencies
import SQLiteData
import SwiftUI
import UIKit

@main
struct MokiApp: App {
  init() {
    AppLogger.configure()
    configureAppDependencies()
    configureAppearance()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
      // 移除强制浅色模式，支持自动深浅色切换
    }
  }
}

func configureAppearance() {
  // 配置导航栏外观以适配 Claude 主题
  let appearance = UINavigationBarAppearance()
  appearance.shadowColor = .clear

  let attrs: [NSAttributedString.Key: Any] = [
    .font: AppFonts.headerTitleUIFont,
    .foregroundColor: UIColor(Theme.color.foreground),
  ]

  // 使用系统 material（更原生、也更接近“毛玻璃”）
  appearance.configureWithTransparentBackground()
  appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
  appearance.backgroundColor = UIColor(Theme.color.background).withAlphaComponent(0.90)
  appearance.titleTextAttributes = attrs
  appearance.largeTitleTextAttributes = attrs
  UINavigationBar.appearance().standardAppearance = appearance
  UINavigationBar.appearance().scrollEdgeAppearance = appearance
  UINavigationBar.appearance().compactAppearance = appearance
}

func configureAppDependencies() {
  prepareDependencies {
    $0.defaultDatabase = AppDatabase.shared
  }
}
