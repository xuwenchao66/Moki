# 左侧边缘拉出菜单功能说明

## 🎯 功能描述

用户可以从屏幕最左侧边缘向右滑动，拉出侧边栏菜单。这是现代移动应用的标准交互模式，提供更自然的用户体验。

## 🏗️ 实现原理

### 1. 双手势系统

重构后的 `SideMenuContainer` 实现了两种手势：

#### **边缘拉出手势** (Edge Drag Gesture)

- **触发区域**：屏幕左侧 30pt 宽的不可见区域
- **触发条件**：仅当侧边栏关闭时生效
- **手势方向**：只响应向右拖动（`translation.width > 0`）
- **用途**：从关闭状态拉出菜单

#### **全屏拖拽手势** (Full Screen Drag Gesture)

- **触发区域**：遮罩层 + 侧边栏区域
- **触发条件**：仅当侧边栏打开时生效
- **手势方向**：双向（开合菜单）
- **用途**：控制已打开的菜单

### 2. 视图层级结构

```
ZStack (alignment: .leading)
├── 0. 左侧边缘触发区域 (zIndex: 0)
│   └── Color.clear (width: 30pt, 不可见)
│       └── edgeDragGesture  // 仅菜单关闭时显示
│
├── 1. 遮罩层 (zIndex: 1)
│   └── Color.black.opacity(...)
│       ├── onTapGesture  // 点击关闭
│       └── fullScreenDragGesture  // 拖动控制
│
└── 2. 侧边栏内容 (zIndex: 2)
    └── SideMenu
        └── fullScreenDragGesture  // 拖动控制
```

### 3. 关键代码实现

```swift
struct SideMenuContainer<Content: View>: View {
  let edgeWidth: CGFloat = 30  // 边缘触发区域宽度

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        // 左侧边缘触发区域（仅菜单关闭时显示）
        if !isShowing {
          Color.clear
            .frame(width: edgeWidth)
            .contentShape(Rectangle())  // 确保手势可触发
            .gesture(edgeDragGesture)
        }

        // 遮罩层和侧边栏（使用 fullScreenDragGesture）
        // ...
      }
    }
  }

  // 边缘拉出手势：只响应向右拖动
  private func edgeDragGesture() -> some Gesture {
    DragGesture(minimumDistance: 10)
      .onChanged { value in
        guard value.translation.width > 0 else { return }
        // 跟手拖动...
      }
      .onEnded { value in
        // 判断是否打开...
      }
  }

  // 全屏拖拽手势：双向控制
  private func fullScreenDragGesture() -> some Gesture {
    DragGesture()
      .onChanged { /* 跟手拖动 */ }
      .onEnded { /* 判断开合 */ }
  }
}
```

## 🎨 交互体验

### 场景 1：从左边缘拉出菜单

1. 用户手指触碰屏幕左侧 30pt 区域
2. 向右滑动，菜单跟随手指移动
3. 释放手指：
   - 滑动距离 > 70pt (1/4 菜单宽度) → 菜单打开
   - 滑动距离 < 70pt → 菜单弹回关闭

### 场景 2：关闭已打开的菜单

**方式 1：点击遮罩**

- 点击菜单外的灰色遮罩区域
- 菜单平滑关闭

**方式 2：向左拖动**

- 在遮罩层或侧边栏区域向左拖动
- 释放手指：
  - 滑动距离 > 70pt → 菜单关闭
  - 滑动距离 < 70pt → 菜单弹回打开

## 🔧 可配置参数

### `edgeWidth`：边缘触发区域宽度

```swift
SideMenuContainer(
  isShowing: $isMenuOpen,
  edgeWidth: 40  // 扩大到 40pt
) {
  SideMenu(...)
}
```

**推荐值**：

- **30pt**（默认）：适合大多数情况
- **20pt**：更精确的控制，减少误触
- **40pt**：更容易触发，适合老年用户

### `menuWidth`：菜单宽度

```swift
SideMenuContainer(
  isShowing: $isMenuOpen,
  menuWidth: 320  // 更宽的菜单
) {
  SideMenu(...)
}
```

## ⚡ 性能优化

### 1. 条件渲染

```swift
// 只在菜单关闭时渲染边缘触发区域
if !isShowing {
  Color.clear
    .frame(width: edgeWidth)
    .gesture(edgeDragGesture)
}
```

### 2. 手势优先级

- 边缘触发手势：仅在菜单关闭时生效，避免与主内容手势冲突
- 全屏拖拽手势：仅在菜单打开时生效，作用于遮罩和侧边栏

### 3. 手势方向检测

```swift
// 边缘拉出只响应向右拖动，避免误触
guard value.translation.width > 0 else { return }
```

## 📱 与原生应用对比

这个实现模仿了 iOS 原生应用（如邮件、文件）的侧边栏交互：

| 特性         | 原生应用 | Moki 实现 | 状态   |
| ------------ | -------- | --------- | ------ |
| 左边缘拉出   | ✅       | ✅        | 已实现 |
| 跟手拖动     | ✅       | ✅        | 已实现 |
| 阈值判断     | ✅       | ✅        | 已实现 |
| 遮罩点击关闭 | ✅       | ✅        | 已实现 |
| 拖动关闭     | ✅       | ✅        | 已实现 |
| 弹性回弹     | ✅       | ⏳        | 可优化 |
| 速度感知     | ✅       | ⏳        | 可优化 |

## 🐛 已知限制

### 1. 与 NavigationStack 的兼容性

如果主内容区域使用了 `NavigationStack` 的返回手势，可能会与边缘拉出手势冲突。

**解决方案**：

- NavigationStack 的返回手势优先级更高
- 边缘触发区域可以适当缩小到 20pt

### 2. 手势冲突

如果主内容区域有横向滚动视图（ScrollView, List），可能会产生手势冲突。

**解决方案**：

- 边缘触发区域足够窄（30pt），避免覆盖主内容
- 添加 `minimumDistance: 10` 确保手势明确性

## 🚀 未来优化方向

### 1. 速度感知关闭

```swift
// 检测手势速度，快速滑动直接关闭
let velocity = value.predictedEndLocation.x - value.location.x
if velocity < -500 {
  setMenu(open: false, animated: true)
}
```

### 2. 弹性回弹效果

```swift
// 使用 spring 动画代替 easeOut
withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
  action()
}
```

### 3. 支持右侧边缘（可选）

```swift
enum Edge {
  case leading  // 左侧
  case trailing // 右侧
}

SideMenuContainer(
  isShowing: $isMenuOpen,
  edge: .trailing  // 从右侧滑出
) {
  SideMenu(...)
}
```

## ✅ 测试清单

- [x] 从左边缘拉出菜单
- [x] 拖动距离不足时回弹关闭
- [x] 拖动距离足够时打开菜单
- [x] 点击遮罩关闭菜单
- [x] 向左拖动关闭菜单
- [x] 选择菜单项后自动关闭
- [x] 不影响主内容区域的正常交互
- [ ] 在真机上测试流畅度
- [ ] 与 NavigationStack 兼容性测试

## 📚 参考资料

- [SwiftUI Gestures](https://developer.apple.com/documentation/swiftui/gestures)
- [DragGesture](https://developer.apple.com/documentation/swiftui/draggesture)
- [Human Interface Guidelines - Navigation](https://developer.apple.com/design/human-interface-guidelines/navigation)

---

**实现日期**：2024-12-09  
**版本**：v1.1  
**贡献者**：AI Assistant
