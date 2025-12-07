# Database 模块使用指南

## 📁 文件结构

```
Database/
├── AppDatabase.swift       # 数据库单例
├── Schema.swift            # 数据模型定义
├── DatabaseMigrator.swift  # 数据库迁移
├── DiaryService.swift      # 日记 CRUD 操作
└── TagService.swift        # 标签 CRUD 操作
```

## 🗄️ 数据模型

### MokiDiary - 日记表

```swift
struct MokiDiary {
  let id: UUID           // 主键
  var text: String       // 日记内容
  var createdAt: Date    // 创建时间
  var updatedAt: Date?   // 修改时间
  var isStarred: Bool    // 是否标星
}
```

### MokiTag - 标签表

```swift
struct MokiTag {
  let id: UUID           // 主键
  var name: String       // 标签名（唯一）
  var color: String?     // 颜色 Hex
  var createdAt: Date    // 创建时间
  var updatedAt: Date?   // 修改时间
}
```

### MokiDiaryTag - 日记-标签关联表

```swift
struct MokiDiaryTag {
  let diaryId: UUID      // 日记 ID（外键）
  let tagId: UUID        // 标签 ID（外键）
  var order: Int         // 显示顺序
  var createdAt: Date    // 关联时间
}
```

**约束**：

- 复合主键 `(diaryId, tagId)` 防止重复关联
- 外键级联删除

## 🔧 服务使用

### DiaryService - 日记操作

```swift
let diaryService = DiaryService()

// 创建日记
let diary = MokiDiary(text: "今天心情不错")
diaryService.create(diary)

// 更新日记
var updatedDiary = diary
updatedDiary.text = "修改内容"
diaryService.update(updatedDiary)

// 删除日记
diaryService.delete(diary)
```

### TagService - 标签操作

#### 基础 CRUD

```swift
let tagService = TagService()

// 创建标签
if let tag = tagService.createTag(name: "工作", color: "#FF5733") {
  print("创建成功: \(tag.name)")
}

// 查询所有标签
let allTags = tagService.fetchAllTags()

// 搜索标签
let searchResults = tagService.searchTags(query: "工作")

// 重命名标签
let success = tagService.renameTag(tag, newName: "学习")

// 删除标签（硬删除）
tagService.deleteTag(tag)  // CASCADE 会自动删除所有关联
```

#### 日记-标签关联

```swift
// 给日记添加标签
tagService.addTag(tagId, toDiary: diaryId)

// 从日记移除标签
tagService.removeTag(tagId, fromDiary: diaryId)

// 批量更新日记的标签
let tagIds = [tag1.id, tag2.id, tag3.id]
tagService.updateTags(tagIds, forDiary: diaryId)

// 查询日记的所有标签
let tags = tagService.fetchTags(forDiary: diaryId)
```

#### 统计功能

```swift
// 获取标签使用统计
let stats = tagService.fetchTagUsageStats()
for (tag, count) in stats {
  print("\(tag.name): 使用了 \(count) 次")
}
```

## 📊 数据库索引

已优化的索引：

| 表名         | 索引                           | 作用                       |
| ------------ | ------------------------------ | -------------------------- |
| `diary_tags` | `idx_diary_tags_tagId`         | 加速通过标签查日记         |
| `diary_tags` | `idx_diary_tags_diaryId_order` | 加速查日记的标签（带排序） |

## ⚠️ 注意事项

### 1. 删除行为

标签使用硬删除（CASCADE），删除后：

- ✅ 标签本身从数据库删除
- ✅ 所有 `diary_tags` 关联自动删除（外键级联）
- ⚠️ 历史日记的标签也会消失（MVP 阶段可接受）

**建议**：UI 层添加确认对话框防止误删

### 2. 唯一性约束

- 标签名称在数据库层面保证唯一（不区分大小写取决于数据库配置）
- 日记-标签关联不会重复（复合主键保证）

### 3. 并发安全

- 所有 Service 都标记为 `@MainActor`
- 在主线程调用，避免并发问题

### 4. 错误处理

- 数据库错误会打印到控制台
- 函数返回空值或 false，不会崩溃

## 🔄 数据迁移

### 自动执行

App 启动时会自动执行未完成的迁移：

```swift
// AppDatabase.swift
static let shared = AppDatabase()

init() {
  // ... 初始化代码
  try? AppDatabaseMigrator.migrate(writer)
}
```

### 迁移历史

1. **Create initial tables** - 创建 diaries 表
2. **create-tags-tables** - 创建 tags 和 diary_tags 表
3. **add-tags-soft-delete** - 添加软删除支持
4. **enhance-diary-tags** - 添加排序和时间戳

## 💡 最佳实践

### 1. 创建日记时添加标签

```swift
// 1. 创建日记
let diary = MokiDiary(text: "今天学习了 SwiftUI")
diaryService.create(diary)

// 2. 创建或获取标签
let swiftTag = tagService.createTag(name: "Swift", color: "#FF5733")

// 3. 关联标签
if let tag = swiftTag {
  tagService.addTag(tag.id, toDiary: diary.id)
}
```

### 2. 显示日记时查询标签

```swift
// 在 TimelineView 中
ForEach(entries) { diary in
  let tags = tagService.fetchTags(forDiary: diary.id)

  JournalCardView(
    content: diary.text,
    date: diary.createdAt,
    tags: tags.map(\.name)
  )
}
```

### 3. 标签管理界面

```swift
struct TagsManagementView: View {
  @State private var tags: [MokiTag] = []
  private let tagService = TagService()

  var body: some View {
    List {
      // 按使用次数排序
      let stats = tagService.fetchTagUsageStats()
      ForEach(stats, id: \.tag.id) { item in
        HStack {
          Circle()
            .fill(Color(hex: item.tag.color ?? "#999999"))
            .frame(width: 12, height: 12)
          Text(item.tag.name)
          Spacer()
          Text("\(item.count)")
            .foregroundColor(.secondary)
        }
      }
    }
    .onAppear {
      tags = tagService.fetchAllTags()
    }
  }
}
```

## 🧪 测试建议

### 单元测试示例

```swift
func testCreateTag() {
  let tagService = TagService()

  // 测试创建
  let tag = tagService.createTag(name: "测试", color: "#FF0000")
  XCTAssertNotNil(tag)
  XCTAssertEqual(tag?.name, "测试")

  // 测试重复创建（应返回现有标签）
  let duplicate = tagService.createTag(name: "测试", color: "#00FF00")
  XCTAssertEqual(duplicate?.id, tag?.id)
}

func testDeleteTag() {
  let tagService = TagService()

  // 创建并删除
  let tag = tagService.createTag(name: "待删除", color: nil)!
  tagService.deleteTag(tag)

  // 验证已从数据库删除
  let allTags = tagService.fetchAllTags()
  XCTAssertFalse(allTags.contains(where: { $0.id == tag.id }))

  // 重新创建同名标签（应该是新的 ID）
  let newTag = tagService.createTag(name: "待删除", color: nil)
  XCTAssertNotEqual(newTag?.id, tag.id)
}
```

## 📚 扩展阅读

- [GRDB 官方文档](https://github.com/groue/GRDB.swift)
- [SQLiteData 使用指南](https://github.com/pointfreeco/swift-dependencies)
- [数据库设计最佳实践](https://www.sqlstyle.guide/)
