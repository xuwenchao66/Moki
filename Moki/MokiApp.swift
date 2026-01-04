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
        .tint(Theme.color.foreground)
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

  // 自定义返回按钮：使用自带素材，轻量缩放到导航栏标准尺寸
  if let baseImage = UIImage(named: AppIconName.caretLeft.rawValue) {
    let targetSize = CGSize(width: AppIconSize.md.value, height: AppIconSize.md.value)
    let resized = baseImage.preparingThumbnail(of: targetSize) ?? baseImage
    let backImage =
      resized
      .withRenderingMode(.alwaysTemplate)  // 允许 tint 着色
      .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0))  // 轻微左移，更接近系统对齐

    appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
  }

  // 设置导航栏按钮（包括返回按钮）的颜色为前景色，与标题一致
  UINavigationBar.appearance().tintColor = UIColor(Theme.color.foreground)

  // 隐藏返回按钮文字
  let backButtonAppearance = UIBarButtonItemAppearance()
  // 1. 将文字设为透明
  let clearAttributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.clear,
    .font: UIFont.systemFont(ofSize: 0.1),
  ]
  backButtonAppearance.normal.titleTextAttributes = clearAttributes
  backButtonAppearance.highlighted.titleTextAttributes = clearAttributes

  appearance.backButtonAppearance = backButtonAppearance

  UINavigationBar.appearance().standardAppearance = appearance
  UINavigationBar.appearance().scrollEdgeAppearance = appearance
  UINavigationBar.appearance().compactAppearance = appearance
}

func configureAppDependencies() {
  prepareDependencies {
    $0.defaultDatabase = AppDatabase.shared
  }
}
