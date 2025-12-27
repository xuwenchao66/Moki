import SwiftUI

enum AppIconName: String {
  case arrowLeftLight = "arrow-left-light"
  case magnifyingGlassLight = "magnifying-glass-light"
  case listLight = "list-light"
  case plusLight = "plus-light"
  case sliderHorizontalLight = "slider-horizontal-light"
  case caretLeftLight = "caret-left-light"
  case fadersHorizontal = "faders-horizontal"
  case plus = "plus"
  case calendarBlank = "calendar-blank"
}

enum AppIconSize: String {
  case s = "s"
  case sm = "sm"
  case m = "m"
  case l = "l"

  var value: CGFloat {
    switch self {
    case .s:
      return 16
    case .sm:
      return 20
    case .m:
      return 24
    case .l:
      return 32
    }
  }
}

struct AppIcon: View {
  let icon: AppIconName
  var size: CGFloat
  var color: Color?

  init(icon: AppIconName, size: CGFloat = 24, color: Color? = AppColors.foreground) {
    self.icon = icon
    self.size = size
    self.color = color
  }

  init(icon: AppIconName, size: AppIconSize = .m, color: Color? = AppColors.foreground) {
    self.icon = icon
    self.size = size.value
    self.color = color
  }

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
