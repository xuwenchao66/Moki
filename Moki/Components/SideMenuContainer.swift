//
//  SideMenuContainer.swift
//  Moki
//
//  侧边栏容器组件
//  负责遮罩层、动画、显示/隐藏逻辑、手势处理
//

import SwiftUI

struct SideMenuContainer<Content: View>: View {
  @Binding var isShowing: Bool
  let menuWidth: CGFloat
  let content: Content
  let edgeWidth: CGFloat  // 左侧边缘触发区域宽度

  /// 当前菜单偏移量（-menuWidth ~ 0），默认隐藏在左侧
  @State private var menuOffset: CGFloat

  init(
    isShowing: Binding<Bool>,
    menuWidth: CGFloat = 280,
    edgeWidth: CGFloat = 30,  // 左侧边缘 30pt 区域可触发
    @ViewBuilder content: () -> Content
  ) {
    self._isShowing = isShowing
    self.menuWidth = menuWidth
    self.edgeWidth = edgeWidth
    self.content = content()
    self._menuOffset = State(initialValue: isShowing.wrappedValue ? 0 : -menuWidth)
  }

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        // 1. 左侧边缘触发区域（不可见，仅用于手势检测）
        if !isShowing {
          Color.clear
            .frame(width: edgeWidth)
            .frame(maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(edgeDragGesture(screenWidth: geometry.size.width))
            .zIndex(0)
        }

        // 2. 遮罩层
        if menuOffset > -menuWidth {
          Color.black
            .opacity(dimmingOpacity)
            .ignoresSafeArea()
            .onTapGesture {
              setMenu(open: false, animated: true)
            }
            .gesture(fullScreenDragGesture(screenWidth: geometry.size.width))
            .zIndex(1)
        }

        // 3. 侧边栏内容
        content
          .frame(width: menuWidth)
          .offset(x: menuOffset)
          .gesture(fullScreenDragGesture(screenWidth: geometry.size.width))
          .zIndex(2)
      }
      .onChange(of: isShowing) { newValue in
        // 外部状态变化时，同步offset
        setMenu(open: newValue, animated: true)
      }
    }
  }

  // MARK: - Gestures

  /// 左侧边缘拖拽手势 - 用于从左边缘拉出菜单
  private func edgeDragGesture(screenWidth: CGFloat) -> some Gesture {
    DragGesture(minimumDistance: 10)
      .onChanged { value in
        // 只响应向右拖动
        guard value.translation.width > 0 else { return }

        let translation = value.translation.width
        let newOffset = -menuWidth + translation

        // 跟手拖动，限制在 [-menuWidth, 0]
        menuOffset = Swift.max(-menuWidth, Swift.min(0, newOffset))
      }
      .onEnded { value in
        let translation = value.translation.width
        let threshold = menuWidth / 4

        // 向右拖超过阈值则打开，否则回到关闭
        if translation > threshold {
          setMenu(open: true, animated: true)
        } else {
          setMenu(open: false, animated: true)
        }
      }
  }

  /// 全屏拖拽手势 - 用于控制已打开的菜单
  private func fullScreenDragGesture(screenWidth: CGFloat) -> some Gesture {
    DragGesture()
      .onChanged { value in
        let translation = value.translation.width
        let base = isShowing ? 0 : -menuWidth
        let newOffset = base + translation

        // 跟手拖动，限制在 [-menuWidth, 0]
        menuOffset = Swift.max(-menuWidth, Swift.min(0, newOffset))
      }
      .onEnded { value in
        let translation = value.translation.width
        let threshold = menuWidth / 4

        if isShowing {
          // 已打开：向左拖超过阈值则关闭，否则回到打开
          if translation < -threshold {
            setMenu(open: false, animated: true)
          } else {
            setMenu(open: true, animated: true)
          }
        } else {
          // 已关闭：向右拖超过阈值则打开，否则回到关闭
          if translation > threshold {
            setMenu(open: true, animated: true)
          } else {
            setMenu(open: false, animated: true)
          }
        }
      }
  }

  // MARK: - Helpers

  private func setMenu(open: Bool, animated: Bool) {
    let action = {
      isShowing = open
      menuOffset = open ? 0 : -menuWidth
    }

    if animated {
      withAnimation(.easeOut(duration: 0.2)) {
        action()
      }
    } else {
      action()
    }
  }

  // MARK: - Computed Properties

  /// 遮罩层透明度 (0 ~ 0.4)
  private var dimmingOpacity: Double {
    // menuOffset: [-menuWidth, 0] → progress: [0, 1]
    let rawProgress = (menuOffset + menuWidth) / menuWidth
    let clamped = max(0, min(1, rawProgress))
    return Double(clamped) * 0.4
  }
}

// MARK: - Preview

#Preview {
  struct PreviewWrapper: View {
    @State private var isShowing = false

    var body: some View {
      ZStack {
        // 主内容区域
        VStack {
          Button("Toggle Menu") {
            isShowing.toggle()
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.2))

        // 侧边栏容器
        SideMenuContainer(isShowing: $isShowing) {
          SideMenu(selectedTab: .constant(.timeline)) {
            isShowing = false
          }
        }
      }
    }
  }

  return PreviewWrapper()
}
