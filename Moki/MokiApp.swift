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
    }
  }
}

func configureAppearance() {
  // 统一导航栏与 body 背景色（便于维护：只改 Assets.xcassets）
  // https://stackoverflow.com/questions/58442508/swiftui-remove-navigationbar-bottom-border

  let appearance = UINavigationBarAppearance()
  appearance.shadowColor = .clear

  // 标题颜色跟随前景色
  let titleColor = (UIColor(named: "foreground") ?? .label)
  appearance.titleTextAttributes = [.foregroundColor: titleColor]
  appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

  let navBar = UINavigationBar.appearance()
  navBar.standardAppearance = appearance
  navBar.scrollEdgeAppearance = appearance
  navBar.compactAppearance = appearance

  // 导航栏按钮/返回箭头颜色
  navBar.tintColor = titleColor
}

func configureAppDependencies() {
  prepareDependencies {
    $0.defaultDatabase = AppDatabase.shared
  }
}
