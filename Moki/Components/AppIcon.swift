import SwiftUI

enum AppIconName: String {
  case fadersHorizontal = "faders-horizontal"
  case plus = "plus"
  case calendarBlank = "calendar-blank"
  case chartBar = "chart-bar"
  case gearSix = "gear-six"
  case hash = "hash"
  case magnifyingGlass = "magnifying-glass"
  case camera = "camera"
  case check = "check"
  case image = "image"
  case caretLeft = "caret-left"
  case list = "list"
  case x = "x"
  case xCircle = "x-circle"
  case bookOpenText = "book-open-text"
  case appLogo = "app-logo"
}

enum AppIconSize: String {
  case xs = "xs"
  case sm = "sm"
  case md = "md"
  case lg = "lg"

  var value: CGFloat {
    switch self {
    case .xs:
      return 16
    case .sm:
      return 20
    case .md:
      return 24
    case .lg:
      return 32
    }
  }
}

struct AppIcon: View {
  let icon: AppIconName
  var width: CGFloat?
  var height: CGFloat?
  var color: Color?

  init(icon: AppIconName, size: CGFloat = 24, color: Color? = AppColors.foreground) {
    self.icon = icon
    self.width = size
    self.height = size
    self.color = color
  }

  init(icon: AppIconName, size: AppIconSize = .md, color: Color? = AppColors.foreground) {
    self.icon = icon
    self.width = size.value
    self.height = size.value
    self.color = color
  }

  /// 指定宽度，高度自适应
  init(icon: AppIconName, width: CGFloat, color: Color? = AppColors.foreground) {
    self.icon = icon
    self.width = width
    self.height = nil
    self.color = color
  }

  /// 指定高度，宽度自适应
  init(icon: AppIconName, height: CGFloat, color: Color? = AppColors.foreground) {
    self.icon = icon
    self.width = nil
    self.height = height
    self.color = color
  }

  var body: some View {
    Image(icon.rawValue)
      .renderingMode(.template)
      .resizable()
      .scaledToFit()
      .frame(width: width, height: height)
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
