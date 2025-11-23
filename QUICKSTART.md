# Moki 快速启动指南 🚀

## 📦 当前项目状态

✅ **已完成的工作**：

1. **完整的设计系统** (DesignSystem/)
   - 颜色系统（基于 Claude 主题 + 木几理念）
   - 字体系统（优雅、易读）
   - 间距、圆角、阴影系统
   - 通用视图修饰符

2. **核心 UI 组件** (Components/)
   - AppCard - 卡片容器
   - AppButton - 品牌按钮（3种样式）
   - TagCapsule - 标签胶囊（遵循"钢笔圈画"理念）
   - EmptyStateView - 空状态占位

3. **工具类** (Utils/)
   - Date+Extensions - 日期格式化工具

4. **预览页面** (Features/Journal/Views/)
   - DesignSystemPreview - 完整的设计系统可视化预览

---

## 🎯 如何运行项目

### 方法 1：在 Xcode 中打开（推荐）

```bash
# 在终端中执行
cd /Users/xuwenchao/projects/Moki
open Moki.xcodeproj
```

然后在 Xcode 中：
1. 选择运行目标（Mac 或模拟器）
2. 点击 ▶️ 运行按钮（或按 ⌘R）
3. 应用启动后会展示设计系统预览页面

### 方法 2：直接双击打开

在 Finder 中找到 `Moki.xcodeproj`，双击打开即可。

---

## 🎨 预览效果

运行后你会看到一个 **TabView** 包含三个标签页：

### 1️⃣ 颜色 (Colors)
- 主色调预览（背景、前景、卡片）
- 强调色预览（琥珀橙、木棕）
- 语义色预览（边框、分割线、悬浮态）
- 功能色预览（成功、警告、错误）
- 标签颜色预览（6 种莫兰迪色）

### 2️⃣ 组件 (Components)
- 按钮样式展示（主按钮、次要按钮、文本按钮）
- 卡片样式展示
- 标签样式展示（描边、纯文字）
- 空状态展示

### 3️⃣ 示例 (Examples)
- 日记卡片的实际应用示例
- 展示如何将设计系统应用到真实场景
- 包含日期分组、时间戳、标签等完整元素

---

## 📊 设计亮点

### 1. 温暖的色调
- 米色背景 (`#F9F7F4`) 而非纯白
- 琥珀橙强调色 (`#E8926B`) 而非刺眼的亮色
- 深棕灰文字 (`#2C2825`) 而非纯黑

### 2. "钢笔圈画"理念
- 标签使用**描边样式**而非实心色块
- 保留视觉流动性，不做阻断
- 像在纸上用彩色笔圈画的感觉

### 3. 呼吸感强
- 大间距设计（16-24pt 为主）
- 卡片式布局，内容独立成块
- 留白充足，不拥挤

### 4. 统一的访问方式
```swift
Theme.color.xxx   // 颜色
Theme.font.xxx    // 字体
Theme.spacing.xxx // 间距
Theme.radius.xxx  // 圆角
Theme.shadow.xxx  // 阴影
```

---

## 🔍 在 Xcode 中预览单个组件

所有组件都支持 SwiftUI Preview，无需运行整个 App：

1. 打开任意组件文件（如 `AppCard.swift`）
2. 点击编辑器右侧的 **Resume** 按钮
3. 或按快捷键：⌥⌘↩︎ (Option + Command + Return)

这样可以快速预览和调试单个组件！

---

## 📂 项目结构一览

```
Moki/
├── DesignSystem/          # 🎨 设计原子（颜色、字体、主题）
│   ├── AppColors.swift    # 完整的颜色系统
│   ├── AppFonts.swift     # 字体层级定义
│   ├── AppTheme.swift     # 统一入口 + 间距/圆角/阴影
│   └── ViewModifiers.swift # .cardStyle()、.primaryButtonStyle() 等
│
├── Components/            # 🧩 通用 UI 组件（可复用）
│   ├── AppCard.swift      # 卡片容器
│   ├── AppButton.swift    # 品牌按钮
│   ├── TagCapsule.swift   # 标签胶囊 + 流式布局
│   └── EmptyStateView.swift # 空状态占位
│
├── Features/              # 📱 业务功能模块
│   └── Journal/
│       ├── Models/        # (待实现) 数据模型
│       └── Views/
│           └── DesignSystemPreview.swift  # 设计系统预览页面
│
├── Utils/                 # 🛠 工具类
│   └── Date+Extensions.swift  # 日期格式化扩展
│
├── Preview Content/       # 🧪 预览数据
│   └── PreviewData.swift  # Mock 日记数据
│
├── MokiApp.swift          # 应用入口
└── ContentView.swift      # 主视图（当前显示设计系统预览）
```

---

## 🎯 下一步开发建议

### 1. 实现 Database 层（优先级：高）

创建以下文件：
```
Database/
├── AppDatabase.swift       # GRDB 数据库配置
├── DatabaseMigrator.swift  # 数据库迁移
└── Persistence.swift       # 预览用内存数据库
```

**任务**：
- 配置 GRDB 连接池
- 定义 SQL 表结构（journal_entries, tags）
- 实现数据库迁移逻辑

---

### 2. 实现 Journal 模块（优先级：高）

创建以下文件：
```
Features/Journal/
├── Models/
│   ├── JournalEntry.swift        # 核心实体（GRDB Record）
│   ├── JournalEntry+Query.swift  # 查询方法扩展
│   └── JournalTag.swift          # 标签实体
└── Views/
    ├── JournalListView.swift     # 首页列表
    ├── JournalEditorView.swift   # 编辑/新建页
    └── JournalCardView.swift     # 单条日记卡片
```

**任务**：
- 实现日记列表展示（流式时间轴）
- 实现日记编辑器（支持文字、图片）
- 实现标签选择和创建

---

### 3. 实现 CloudKit 同步（优先级：中）

创建以下文件：
```
Cloud/
├── SyncManager.swift         # 核心同步逻辑
└── CloudKitExtensions.swift  # CloudKit 辅助方法
```

**任务**：
- 配置 CloudKit 容器
- 实现增量同步逻辑（上传/下载）
- 实现冲突解决策略

---

### 4. 实现搜索功能（优先级：中）

创建以下文件：
```
Features/Search/
├── SearchView.swift
└── SearchViewModel.swift
```

**任务**：
- 实现全文搜索（FTS5）
- 实现标签筛选
- 实现日期范围筛选

---

### 5. 实现设置页面（优先级：低）

创建以下文件：
```
Features/Settings/
├── SettingsView.swift
└── BackupView.swift
```

**任务**：
- 实现主题切换（亮色/暗色）
- 实现数据导入导出
- 实现隐私保护设置（FaceID）

---

## 💡 开发建议

### 使用设计系统的最佳实践

1. **颜色** - 始终使用 `Theme.color.xxx`，避免硬编码
2. **字体** - 始终使用 `Theme.font.xxx`
3. **间距** - 使用 `Theme.spacing.xxx`（避免魔法数字）
4. **修饰符** - 优先使用 `.cardStyle()`、`.primaryButtonStyle()` 等

### 代码风格建议

```swift
// ✅ 好 - 使用设计系统
Text("标题")
    .font(Theme.font.title2)
    .foregroundColor(Theme.color.foreground)

// ❌ 避免 - 硬编码
Text("标题")
    .font(.system(size: 22, weight: .semibold))
    .foregroundColor(Color(red: 0.17, green: 0.16, blue: 0.15))
```

---

## 📚 参考文档

- **设计系统详细文档**：[DESIGN_SYSTEM.md](DESIGN_SYSTEM.md)
- **品牌理念**：[README.md](README.md)

---

## ⚡️ 快速命令

```bash
# 打开项目
open Moki.xcodeproj

# 查看项目结构
tree -L 3 -I 'xcuserdata|.git|Assets.xcassets' Moki/

# 查找所有 Swift 文件
find Moki -name "*.swift" -type f | grep -v xcuserdata
```

---

## 🎉 总结

当前项目已经完成了 **设计系统基础架子**，包括：

✅ 完整的颜色/字体/间距系统  
✅ 4 个核心 UI 组件  
✅ 通用修饰符和工具类  
✅ 可视化预览页面  
✅ Mock 数据用于开发测试  

**项目已经可以运行并展示设计系统预览！🚀**

打开 Xcode，点击运行，即可看到完整的设计系统展示。

---

**Enjoy coding! 💻✨**

