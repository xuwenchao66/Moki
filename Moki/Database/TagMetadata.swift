//
//  TagMetadata.swift
//  Moki
//
//  Tag 的 metadata 解析和构建工具
//

import Foundation

// MARK: - Tag Metadata 结构

/// Tag 的元数据结构（从 JSON 解析）
struct TagMetadata: Codable {
  /// 展示模式
  enum DisplayMode: String, Codable {
    case tag = "tag"  // 普通标签
    case book = "book"  // 书籍形态
  }

  /// 展示模式（默认为普通标签）
  var displayMode: DisplayMode = .tag

  /// Emoji 图标（可选）
  var icon: String?

  /// 封面图片（本地文件名或 URL，仅 book 模式）
  var coverImage: String?

  /// 封面背景色（Hex 格式，仅 book 模式）
  var coverColor: String?

  /// 描述文本（仅 book 模式）
  var description: String?
}

// MARK: - MokiTag Extension

extension MokiTag {
  /// 解析 metadata 为结构化对象
  var parsedMetadata: TagMetadata {
    guard let data = metadata.data(using: .utf8),
      let decoded = try? JSONDecoder().decode(TagMetadata.self, from: data)
    else {
      return TagMetadata()  // 返回默认值
    }
    return decoded
  }

  /// 是否为书籍形态
  var isBookMode: Bool {
    parsedMetadata.displayMode == .book
  }

  /// 获取显示图标（优先使用 metadata.icon，否则使用 emoji）
  var displayIcon: String? {
    parsedMetadata.icon
  }

  /// 获取封面背景色（如果有）
  var bookCoverColor: String? {
    guard isBookMode else { return nil }
    return parsedMetadata.coverColor ?? color
  }

  /// 获取书籍描述（如果有）
  var bookDescription: String? {
    guard isBookMode else { return nil }
    return parsedMetadata.description
  }

  /// 更新 metadata（便捷方法）
  mutating func updateMetadata(_ builder: (inout TagMetadata) -> Void) {
    var meta = parsedMetadata
    builder(&meta)

    if let encoded = try? JSONEncoder().encode(meta),
      let jsonString = String(data: encoded, encoding: .utf8)
    {
      self.metadata = jsonString
    }
  }
}

// MARK: - 便捷构造器

extension MokiTag {
  /// 创建普通标签
  static func createTag(
    name: String,
    color: String? = nil,
    icon: String? = nil
  ) -> MokiTag {
    var tag = MokiTag(name: name, color: color)

    if let icon = icon {
      tag.updateMetadata { meta in
        meta.icon = icon
      }
    }

    return tag
  }

  /// 创建书籍形态的标签
  static func createBook(
    name: String,
    coverColor: String? = nil,
    coverImage: String? = nil,
    description: String? = nil
  ) -> MokiTag {
    var tag = MokiTag(name: name, color: coverColor)

    tag.updateMetadata { meta in
      meta.displayMode = .book
      meta.coverColor = coverColor
      meta.coverImage = coverImage
      meta.description = description
    }

    return tag
  }
}
