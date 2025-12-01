//
//  ContentView.swift
//  Moki
//
//  Created by xuwecnhao on 11/23/25.
//

import SwiftUI

struct ContentView: View {
  @State private var isMenuOpen = false

  /// 当前菜单偏移量（-menuWidth ~ 0），默认隐藏在左侧
  @State private var menuOffset: CGFloat = -280

  private let menuWidth: CGFloat = 280

  var body: some View {
    ZStack(alignment: .leading) {
      // 1. 主内容区域 - 固定不动
      TimelineView(
        isSideMenuPresented: Binding(
          get: { isMenuOpen },
          set: { newValue in
            setMenu(open: newValue, animated: true)
          }
        )
      )
      .disabled(isMenuOpen)

      // 2. 遮罩层
      if menuOffset > -menuWidth {
        Color.black
          .opacity(dimmingOpacity)
          .ignoresSafeArea()
          .onTapGesture {
            setMenu(open: false, animated: true)
          }
          .zIndex(1)
      }

      // 3. 侧边栏 - 始终存在，通过 offset 控制
      SideMenu()
        .frame(width: menuWidth)
        .offset(x: menuOffset)
        .zIndex(2)
    }
    .gesture(
      DragGesture()
        .onChanged { value in
          let translation = value.translation.width
          let base = isMenuOpen ? 0 : -menuWidth
          let newOffset = base + translation

          // 跟手拖动，限制在 [-menuWidth, 0]
          menuOffset = Swift.max(-menuWidth, Swift.min(0, newOffset))
        }
        .onEnded { value in
          let translation = value.translation.width
          // 降低开合阈值，让轻扫也能触发。约为菜单宽度的 1/4
          let threshold = menuWidth / 4

          if isMenuOpen {
            // 已打开：向左拖超过阈值则关闭，否则回到打开
            if translation < -threshold {
              setMenu(open: false, animated: true)
            } else {
              setMenu(open: true, animated: true)
            }
          } else {
            // 已关闭：向右拖超过一半则打开，否则回到关闭
            if translation > threshold {
              setMenu(open: true, animated: true)
            } else {
              setMenu(open: false, animated: true)
            }
          }
        }
    )
  }

  // MARK: - Helpers

  private func setMenu(open: Bool, animated: Bool) {
    let action = {
      isMenuOpen = open
      menuOffset = open ? 0 : -menuWidth
    }
    if animated {
      withAnimation(.easeOut(duration: 0.2), action)
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

#Preview {
  configureAppDependencies()
  return ContentView()
}
