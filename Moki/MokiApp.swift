//
//  MokiApp.swift
//  Moki
//
//  Created by xuwecnhao on 11/23/25.
//

import Dependencies
import SQLiteData
import SwiftUI

@main
struct MokiApp: App {
  init() {
    configureAppDependencies()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

func configureAppDependencies() {
  prepareDependencies {
    $0.defaultDatabase = AppDatabase.shared
  }
}
