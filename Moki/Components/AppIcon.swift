import SwiftUI

enum AppIconName: String {
  case arrowLeft = "arrow-left-light"
  case magnifyingGlass = "magnifying-glass-light"
  case list = "list-light"
  case plus = "plus-light"
  case sliderHorizontal = "slider-horizontal-light"
  case caretLeft = "caret-left-light"
  case fadersHorizontal = "faders-horizontal-light"
}

struct AppIcon: View {
  let icon: AppIconName
  var size: CGFloat = 24
  var color: Color? = AppColors.foreground

  var body: some View {
    Image(icon.rawValue)
      .renderingMode(.template)
      .resizable()
      .scaledToFit()
      .frame(width: size, height: size)
      .foregroundColor(color)
  }
}

// 扩展一个便捷方法，为图标提供更大的可点击区域（默认 44x44），图标保持居中
extension AppIcon {
  func withTapArea(_ tapSize: CGFloat = 44) -> some View {
    self
      .frame(width: tapSize, height: tapSize, alignment: .center)
      .contentShape(Rectangle())
  }
}
