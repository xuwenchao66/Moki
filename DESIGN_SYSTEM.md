# Moki 设计系统使用指南

## 🎨 设计理念

Moki 的设计系统基于品牌核心价值：**简约、温暖、平静、低摩擦**。

### 核心设计原则

1. **温暖的色调** - 米色、暖白、纸张感，而非纯白纯黑
2. **呼吸感** - 大留白，不做视觉阻断
3. **内容优先** - UI 元素退后，让内容成为主角
4. **钢笔圈画** - 标签使用文字颜色而非色块背景

---

## 📦 目录结构

```
Moki/
├── DesignSystem/          # 🎨 设计原子
│   ├── AppColors.swift    # 颜色系统
│   ├── AppFonts.swift     # 字体系统
│   ├── AppTheme.swift     # 统一入口 (Theme.color.xxx)
│   └── ViewModifiers.swift # 通用修饰符
│
├── Components/            # 🧩 通用 UI 组件
│   ├── AppCard.swift      # 卡片容器
│   ├── AppButton.swift    # 品牌按钮
│   ├── TagCapsule.swift   # 标签胶囊
│   └── EmptyStateView.swift # 空状态
│
├── Features/              # 📱 业务功能模块
│   └── Journal/
│       └── Views/
│           └── DesignSystemPreview.swift  # 设计系统预览页面
│
└── Utils/                 # 🛠 工具类
    └── Date+Extensions.swift  # 日期扩展
```

---

## 🚀 快速开始

### 1. 在 Xcode 中打开项目

```bash
open Moki.xcodeproj
```

### 2. 运行项目

- 点击 Xcode 左上角的 **Run** 按钮 (⌘R)
- 或选择 Product → Run

### 3. 预览设计系统

项目启动后会自动展示设计系统预览页面，包含三个 Tab：

- **颜色** - 完整的颜色系统预览
- **组件** - 所有 UI 组件展示
- **示例** - 日记卡片的实际应用示例

---

## 🎨 使用设计系统

### 颜色使用

```swift
// ✅ 推荐：通过 Theme 访问
Text("Hello")
    .foregroundColor(Theme.color.foreground)
    .background(Theme.color.background)

// ✅ 直接使用语义化颜色
Button("保存") {}
    .foregroundColor(Theme.color.accent)
```

### 字体使用

```swift
// ✅ 使用预定义字体
Text("标题")
    .font(Theme.font.title2)

Text("正文")
    .font(Theme.font.body)

Text("辅助信息")
    .font(Theme.font.caption)
```

### 间距使用

```swift
// ✅ 使用标准间距
VStack(spacing: Theme.spacing.md) {
    // ...
}

.padding(Theme.spacing.lg)
```

### 修饰符使用

```swift
// ✅ 使用卡片样式
VStack {
    Text("内容")
}
.cardStyle()  // 应用标准卡片样式

// ✅ 使用按钮样式
Button("保存") {}
    .primaryButtonStyle()

Button("取消") {}
    .secondaryButtonStyle()
```

---

## 🧩 组件使用示例

### 1. AppCard - 卡片容器

```swift
AppCard {
    VStack(alignment: .leading) {
        Text("标题")
            .titleStyle()
        Text("内容")
            .subtitleStyle()
    }
}
```

### 2. AppButton - 品牌按钮

```swift
// 主按钮
AppButton("创建", icon: "plus.circle.fill", style: .primary) {
    // 点击事件
}

// 次要按钮
AppButton("取消", style: .secondary) {
    // 点击事件
}

// 文本按钮
AppButton("了解更多", style: .text) {
    // 点击事件
}
```

### 3. TagCapsule - 标签

```swift
// 单个标签
TagCapsule("Naval", color: Theme.color.accent, style: .outlined)

// 标签流式布局
TagFlowLayout(
    tags: ["Naval", "幸福", "成长"],
    style: .outlined
)
```

### 4. EmptyStateView - 空状态

```swift
EmptyStateView(
    icon: "book.closed",
    title: "还没有日记",
    message: "开始记录你的第一条想法吧",
    actionTitle: "创建日记"
) {
    // 创建日记的逻辑
}
```

---

## 🎨 颜色系统

### 主色调 (Primary)

- `Theme.color.background` - 主背景色（米色）
- `Theme.color.cardBackground` - 卡片背景（白色）
- `Theme.color.foreground` - 主文字色（深棕灰）
- `Theme.color.foregroundSecondary` - 次要文字色
- `Theme.color.foregroundTertiary` - 三级文字色

### 强调色 (Accent)

- `Theme.color.accent` - 琥珀橙（主强调色）
- `Theme.color.accentForeground` - 强调色上的文字（白色）
- `Theme.color.accentSecondary` - 木棕色（次要强调）

### 语义色 (Semantic)

- `Theme.color.border` - 边框色
- `Theme.color.divider` - 分割线
- `Theme.color.hover` - 悬浮态
- `Theme.color.selected` - 选中态

### 功能色 (Functional)

- `Theme.color.success` - 成功色（莫兰迪绿）
- `Theme.color.warning` - 警告色（莫兰迪黄）
- `Theme.color.destructive` - 错误色（莫兰迪红）

### 标签颜色

- `Theme.color.tagColors` - 6 种预定义的标签颜色数组

---

## 📐 间距系统

```swift
Theme.spacing.xxs  // 4pt
Theme.spacing.xs   // 8pt
Theme.spacing.sm   // 12pt
Theme.spacing.md   // 16pt (默认)
Theme.spacing.lg   // 24pt
Theme.spacing.xl   // 32pt
Theme.spacing.xxl  // 48pt
```

---

## 🔄 圆角系统

```swift
Theme.radius.none  // 0pt
Theme.radius.xxs   // 2pt
Theme.radius.xs    // 4pt
Theme.radius.sm    // 8pt
Theme.radius.md    // 12pt (卡片默认)
Theme.radius.lg    // 16pt
Theme.radius.xl    // 24pt
Theme.radius.full  // 9999pt (圆形)
```

---

## 🌗 阴影系统

```swift
Theme.shadow.none  // 无阴影
Theme.shadow.xs    // 极小阴影
Theme.shadow.sm    // 小阴影（卡片默认）
Theme.shadow.md    // 中等阴影
Theme.shadow.lg    // 大阴影
Theme.shadow.xl    // 超大阴影
```

---

## ✏️ 字体系统

### 标题字体

```swift
Theme.font.largeTitle  // 34pt, bold, serif
Theme.font.title1      // 28pt, semibold
Theme.font.title2      // 22pt, semibold
Theme.font.title3      // 20pt, medium
```

### 正文字体

```swift
Theme.font.body        // 17pt (日记内容)
Theme.font.callout     // 16pt (辅助说明)
Theme.font.subheadline // 15pt (元数据)
Theme.font.footnote    // 13pt
Theme.font.caption     // 12pt (提示文字)
Theme.font.caption2    // 11pt (时间戳)
```

### 特殊字体

```swift
Theme.font.tag         // 13pt, medium, rounded (标签)
Theme.font.button      // 16pt, semibold, rounded (按钮)
Theme.font.monospaced  // 15pt, monospaced (代码/数字)
```

---

## 🎯 设计原则实践

### ✅ 推荐做法

1. **标签使用描边样式**

```swift
// ✅ 好 - 保留呼吸感
TagCapsule("Naval", style: .outlined)

// ❌ 避免 - 打破视觉流动性
TagCapsule("Naval", style: .filled)
```

2. **留白要充足**

```swift
// ✅ 好 - 大间距，呼吸感强
VStack(spacing: Theme.spacing.lg) { }

// ❌ 避免 - 拥挤
VStack(spacing: 4) { }
```

3. **内容优先，元数据退后**

```swift
// ✅ 好 - 主内容用主色，元数据用浅色
Text("日记内容").foregroundColor(Theme.color.foreground)
Text("时间").foregroundColor(Theme.color.foregroundTertiary)
```

---

## 🧪 在 SwiftUI Preview 中测试

所有组件都支持 SwiftUI Preview，可以直接在 Xcode 中实时预览：

```swift
#Preview {
    VStack {
        AppCard {
            Text("测试卡片")
        }
    }
    .padding()
    .background(Theme.color.background)
}
```

---

## 🎨 颜色来源

颜色方案参考了：
- **Claude 主题** - 现代、简洁的设计风格
- **木几理念** - 温暖的木质感、纸张感
- **莫兰迪色系** - 低饱和度、温柔、不刺眼

---

## 📝 下一步开发建议

1. ✅ **DesignSystem 已完成** - 颜色、字体、间距、组件
2. ⏭️ **实现 Database 层** - GRDB 数据库和迁移
3. ⏭️ **实现 Journal 模块** - 日记列表、编辑器
4. ⏭️ **实现 CloudKit 同步** - 数据云同步
5. ⏭️ **实现搜索功能** - 全文搜索
6. ⏭️ **实现设置页面** - 偏好设置、数据备份

---

## 🎉 总结

当前已完成：
- ✅ 完整的设计系统（颜色、字体、间距、圆角、阴影）
- ✅ 4 个核心 UI 组件（Card、Button、Tag、EmptyState）
- ✅ 通用视图修饰符（cardStyle、buttonStyle 等）
- ✅ 工具类扩展（Date 扩展）
- ✅ 设计系统预览页面（可视化展示所有元素）
- ✅ Mock 数据（用于开发测试）

项目已经可以运行，并展示完整的设计系统预览！🚀

