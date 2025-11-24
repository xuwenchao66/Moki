//
//  DayOneImporter.swift
//  Moki
//
//  Day One 数据导入工具
//  用于解析 Day One 导出的 JSON 格式
//

import Foundation

// MARK: - Day One JSON Data Models

struct DayOneExport: Codable {
  let metadata: DayOneMetadata
  let entries: [DayOneEntry]
}

struct DayOneMetadata: Codable {
  let version: String
}

struct DayOneEntry: Codable {
  let uuid: String
  let text: String?  // Day One 有时 text 可能为空，但我们转换时会处理
  let creationDate: String  // ISO8601 String
  let modifiedDate: String?
  let timeZone: String?
  let starred: Bool
  let tags: [String]?
  let photos: [DayOnePhoto]?

  // Moki 不需要的字段可以省略，或者设为 Optional
  // let location: DayOneLocation?
  // let weather: DayOneWeather?
}

struct DayOnePhoto: Codable {
  let identifier: String
  let filename: String
  let type: String
  let width: Int
  let height: Int
  let md5: String?
}

// MARK: - Converter

extension JournalEntry {
  /// 将 Day One 条目转换为 Moki 条目
  static func from(dayOneEntry: DayOneEntry) -> JournalEntry? {
    // 1. 必须有 UUID
    guard let uuid = UUID(uuidString: dayOneEntry.uuid) else { return nil }

    // 2. 必须有文本 (如果为空，给个默认值或者跳过，这里给空字符串)
    let content = dayOneEntry.text ?? ""

    // 3. 解析日期
    let formatter = ISO8601DateFormatter()
    // Day One 格式通常是 "2024-09-27T05:57:39Z"
    guard let createdDate = formatter.date(from: dayOneEntry.creationDate) else { return nil }

    // 4. 转换图片元数据
    let entryPhotos =
      dayOneEntry.photos?.map { photo in
        EntryPhoto(
          identifier: photo.identifier,
          filename: photo.filename,
          width: photo.width,
          height: photo.height
        )
      } ?? []

    return JournalEntry(
      id: uuid,
      text: content,
      createdAt: createdDate,
      tags: dayOneEntry.tags ?? [],
      photos: entryPhotos,
      isStarred: dayOneEntry.starred
    )
  }
}
