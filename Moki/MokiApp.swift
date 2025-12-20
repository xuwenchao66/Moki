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
  
  // 使用主题背景色
  appearance.backgroundColor = UIColor(Theme.color.background)
  
  UINavigationBar.appearance().standardAppearance = appearance
  UINavigationBar.appearance().scrollEdgeAppearance = appearance
}

func configureAppDependencies() {
  prepareDependencies {
    $0.defaultDatabase = AppDatabase.shared
  }
}
