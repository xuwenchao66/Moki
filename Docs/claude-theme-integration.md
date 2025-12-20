# Claude 主题集成文档

## 🎨 设计理念

Moki 现已采用 [Anthropic Claude](https://www.anthropic.com/) 的温暖橙色主题配色方案，为用户带来专业而舒适的视觉体验。

### 核心特点

- **温暖专业**：主色调采用 Claude 标志性的橙色（#c96442），传递温暖与专业感
- **自适应主题**：完整支持浅色和深色模式自动切换
- **精心设计**：基于 OKLCH 色彩空间，确保视觉一致性和可访问性
- **层次分明**：从背景到前景，从柔和到强调，层次清晰

---

## 🎯 配色系统

### 基础色

| 颜色名         | 浅色模式           | 深色模式       | 用途     |
| -------------- | ------------------ | -------------- | -------- |
| **Background** | `#F5F5F4` 温暖米白 | `#2D2E2E` 深灰 | 主背景色 |
| **Foreground** | `#373936` 深灰     | `#B9BAB8` 浅灰 | 主文字色 |

### 主题色

| 颜色名                 | 浅色模式         | 深色模式         | 用途           |
| ---------------------- | ---------------- | ---------------- | -------------- |
| **Primary**            | `#9E8066` 温暖橙 | `#AA8C75` 柔和橙 | 主要交互、强调 |
| **Primary Foreground** | `#FFFFFF` 白色   | `#FFFFFF` 白色   | 主色按钮文字   |

### 次要色

| 颜色名        | 浅色模式         | 深色模式         | 用途     |
| ------------- | ---------------- | ---------------- | -------- |
| **Secondary** | `#E1E1DF` 浅灰   | `#FAF6F3` 温暖白 | 次要背景 |
| **Muted**     | `#EEECE8` 柔和灰 | `#252424` 深灰   | 柔和背景 |
| **Accent**    | `#DFDDD8` 温暖灰 | `#212121` 深灰   | 强调背景 |

### 功能色

| 颜色名     | 浅色模式         | 深色模式         | 用途         |
| ---------- | ---------------- | ---------------- | ------------ |
| **Border** | `#D6D5D0` 浅边框 | `#3C3D3C` 深边框 | 边框、分割线 |
| **Input**  | `#AEB0AE` 中性灰 | `#6E6E6F` 中性灰 | 输入框边框   |
| **Ring**   | `#9E8066` 温暖橙 | `#AA8C75` 柔和橙 | 焦点环       |
| **Card**   | `#F5F5F4` 卡片色 | `#2D2E2E` 卡片色 | 卡片背景     |

### 语义色

| 颜色名                     | 浅色模式       | 深色模式       | 用途         |
| -------------------------- | -------------- | -------------- | ------------ |
| **Destructive**            | `#1A1D1D` 深黑 | `#141413` 黑色 | 危险操作     |
| **Destructive Foreground** | `#FFFFFF` 白色 | `#FFFFFF` 白色 | 危险操作文字 |

---

## 📱 应用场景

### 1. **时间轴页面（Timeline）**

- **背景**：使用 `Background` 营造温暖舒适的阅读环境
- **时间线**：使用 `Input` 作为线条颜色，用 `Primary` 作为时间节点，突出时间流动感
- **FAB 按钮**：使用 `Primary` 配色，悬浮在右下角，温暖醒目
- **日记卡片**：使用 `Card` 背景，配合 `Foreground` 文字，清晰易读

### 2. **编辑页面（Edit）**

- **日期头部**：使用 `Foreground` 作为主标题色，`Foreground Secondary` 作为元数据色
- **文本编辑器**：主文字使用 `Foreground`，光标使用 `Primary` 橙色
- **占位符**：使用 `Muted Foreground` 柔和提示
- **完成按钮**：`Primary` 背景配 `Primary Foreground` 文字，温暖的 CTA

### 3. **标签页面（Tags）**

- **列表项**：使用 `Foreground` 文字配 `Card` 背景
- **空状态**：使用 `Muted Foreground` 图标和说明文字
- **操作菜单**：使用 `Foreground Tertiary` 的省略号图标

### 4. **侧边栏菜单（Side Menu）**

- **选中项**：使用 `Primary` 橙色高亮，清晰指示当前位置
- **未选中项**：使用 `Foreground Secondary` 柔和显示
- **背景**：使用 `Background` 保持整体一致性

### 5. **组件库**

#### 按钮（AppButton）

- **主按钮**：`Primary` 背景 + `Primary Foreground` 文字，温暖醒目
- **次要按钮**：`Secondary` 背景 + `Border` 描边，柔和内敛
- **文本按钮**：`Foreground` 文字，简洁轻量

#### 卡片（AppCard）

- **背景**：使用 `Card` 色，在深浅模式下都保持舒适
- **阴影**：使用 `Theme.shadow` 系统，营造层次感

#### 空状态（EmptyState）

- **图标**：`Muted Foreground` 柔和灰色
- **标题**：`Foreground` 主文字色
- **说明**：`Foreground Secondary` 次要文字色

---

## 🎯 设计亮点

### 1. **温暖的橙色主题**

继承了 Claude 网站的温暖专业气质，主色调 `#9E8066` 既不失专业，又带来温暖舒适的视觉体验。

### 2. **完整的深色模式支持**

每个颜色都精心设计了深浅两个版本，确保在任何环境下都有最佳的阅读体验。

### 3. **语义化命名**

所有颜色都通过 Assets Color Set 管理，代码中使用语义化命名（如 `Theme.color.primary`），易于维护和扩展。

### 4. **渐进式应用**

从基础色到功能色，从组件到页面，层层递进，确保整体视觉一致性。

### 5. **可访问性优先**

基于 OKLCH 色彩空间，确保颜色对比度符合 WCAG 标准，照顾色盲色弱用户。

---

## 🔧 技术实现

### Color Assets 结构

```
Assets.xcassets/
├── Background.colorset/
├── Foreground.colorset/
├── Primary.colorset/
├── PrimaryForeground.colorset/
├── Secondary.colorset/
├── SecondaryForeground.colorset/
├── Muted.colorset/
├── MutedForeground.colorset/
├── Accent.colorset/
├── AccentForeground.colorset/
├── Border.colorset/
├── Input.colorset/
├── Ring.colorset/
├── Card.colorset/
├── CardForeground.colorset/
├── Destructive.colorset/
└── DestructiveForeground.colorset/
```

### 代码引用方式

```swift
// 直接使用 Theme 命名空间
Theme.color.background
Theme.color.primary
Theme.color.foreground

// 兼容性别名（可选）
Theme.color.foregroundSecondary  // -> mutedForeground
Theme.color.foregroundTertiary   // -> mutedForeground
```

---

## 🎨 视觉效果

### 浅色模式特点

- 温暖的米白色背景（#F5F5F4）
- 深灰色文字（#373936）
- 橙色强调（#9E8066）
- 整体温暖、舒适、专业

### 深色模式特点

- 深灰色背景（#2D2E2E）
- 浅灰色文字（#B9BAB8）
- 柔和橙色强调（#AA8C75）
- 整体优雅、温暖、易读

---

## 📚 参考资源

- **设计源**：[Anthropic Claude Website](https://www.anthropic.com/)
- **配色方案**：[Claude Theme JSON](https://tweakcn.com/r/themes/claude.json)
- **色彩空间**：OKLCH (Oklab Lightness Chroma Hue)

---

## ✨ 总结

通过采用 Claude 的温暖主题，Moki 应用在保持极简设计的同时，注入了温暖与专业的气质。完整的深浅色模式支持、精心设计的色彩层次、语义化的颜色管理，共同打造了一个舒适、易用、赏心悦目的日记应用。

**"简约而不简单，温暖而不失专业。"** 这正是 Claude 主题为 Moki 带来的核心价值。
