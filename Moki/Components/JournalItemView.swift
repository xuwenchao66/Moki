import SwiftUI

struct JournalItemView: View {
  let content: String
  let date: Date
  let tags: [String]
  var images: [String] = []

  // Callbacks
  var onEditTapped: (() -> Void)? = nil
  var onDeleteTapped: (() -> Void)? = nil

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(content)
        .font(Theme.font.journalBody)
        .foregroundColor(Theme.color.foreground)
        .lineSpacing(Theme.spacing.compact)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.bottom, Theme.spacing.sm)

      if !images.isEmpty {
        MediaRowView(images: images)
          .padding(.bottom, Theme.spacing.sm)
      }

      HStack(alignment: .center, spacing: Theme.spacing.sm) {
        Text(timeString)
          .font(Theme.font.footnote)
          .foregroundColor(Theme.color.mutedForeground)

        if !tags.isEmpty {
          ForEach(tags, id: \.self) { tag in
            TagText(tag: tag)
          }
        }

        Spacer(minLength: 0)
      }
    }
    .contentShape(Rectangle())
    .contextMenu {
      if let onEditTapped {
        Button(action: onEditTapped) { Label("编辑", systemImage: "pencil") }
      }
      if let onDeleteTapped {
        Button(role: .destructive, action: onDeleteTapped) {
          Label("删除", systemImage: "trash")
        }
      }
    }
  }

  private var timeString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
}

private struct TagText: View {
  let tag: String

  var body: some View {
    HStack(spacing: 1) {
      Text("#")
        .opacity(0.5)
      Text(tag)
    }
    .font(Theme.font.footnote)
    .foregroundColor(Theme.color.mutedForeground)
  }
}

private struct MediaRowView: View {
  let images: [String]

  var body: some View {
    let count = images.count
    switch count {
    case 1:
      MediaPlaceholderView()
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radius.md, style: .continuous))

    case 2:
      HStack(spacing: Theme.spacing.xs) {  // ~8
        MediaPlaceholderView()
        MediaPlaceholderView()
      }
      .frame(height: 150)
      .clipShape(RoundedRectangle(cornerRadius: Theme.radius.md, style: .continuous))

    default:
      // 简单退化：多图按 2 列网格展示，保持紧凑节奏
      LazyVGrid(
        columns: [GridItem(.flexible(), spacing: Theme.spacing.xs), GridItem(.flexible())],
        spacing: Theme.spacing.xs
      ) {
        ForEach(0..<min(count, 6), id: \.self) { _ in
          MediaPlaceholderView()
            .aspectRatio(1, contentMode: .fill)
        }
      }
      .clipShape(RoundedRectangle(cornerRadius: Theme.radius.md, style: .continuous))
    }
  }
}

private struct MediaPlaceholderView: View {
  var body: some View {
    ZStack {
      Theme.color.muted
      Text("Image")
        .font(.system(size: 14, weight: .regular, design: .default))
        .foregroundColor(Theme.color.mutedForeground)
    }
    .clipped()
  }
}
