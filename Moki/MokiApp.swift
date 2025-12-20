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
        .preferredColorScheme(.light)  // 强制使用浅色模式
    }
  }
}

func configureAppearance() {
  // https://stackoverflow.com/questions/58442508/swiftui-remove-navigationbar-bottom-border
  let appearance = UINavigationBarAppearance()
  appearance.shadowColor = .clear
  appearance.backgroundColor = .white  // 设置背景色为白色
  UINavigationBar.appearance().standardAppearance = appearance
  UINavigationBar.appearance().scrollEdgeAppearance = appearance
}

func configureAppDependencies() {
  prepareDependencies {
    $0.defaultDatabase = AppDatabase.shared
  }
}
