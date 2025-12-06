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
  // https://stackoverflow.com/questions/58442508/swiftui-remove-navigationbar-bottom-border
  let appearance = UINavigationBarAppearance()
  appearance.shadowColor = .clear
  UINavigationBar.appearance().standardAppearance = appearance
  UINavigationBar.appearance().scrollEdgeAppearance = appearance
}

func configureAppDependencies() {
  prepareDependencies {
    $0.defaultDatabase = AppDatabase.shared
  }
}
