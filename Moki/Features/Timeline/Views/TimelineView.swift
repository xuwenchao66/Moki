//
//  TimelineView.swift
//  Moki
//
//  日记时间轴首页
//  展示按日期分组的日记流
//

import SwiftUI

struct TimelineView: View {
    // 模拟数据结构
    struct JournalEntry: Identifiable {
        let id = UUID()
        let content: String
        let time: String
        let tags: [String]
        var images: [String] = []
    }
    
    struct DailyJournal: Identifiable {
        let id = UUID()
        let date: String
        let entries: [JournalEntry]
    }
    
    // 模拟数据
    let journalData: [DailyJournal] = [
        DailyJournal(date: "2025-11-23", entries: [
            JournalEntry(
                content: "欲望是你跟自己签的协议：在得到你想要的东西之前，你一直不会快乐。",
                time: "23:42:15",
                tags: ["Naval", "幸福"]
            )
        ]),
        DailyJournal(date: "2025-11-22", entries: [
            JournalEntry(
                content: "对行动要有急迫感，对结果要有耐心。",
                time: "15:20:08",
                tags: ["Naval", "智慧"],
                images: ["photo1", "photo2"]
            ),
            JournalEntry(
                content: "幸福是一种技能，就像健身和赚钱一样。",
                time: "11:05:33",
                tags: ["Naval", "成长"]
            )
        ]),
        DailyJournal(date: "2025-11-21", entries: [
            JournalEntry(
                content: "阅读比听更有效率。做比看更有效率。",
                time: "19:15:42",
                tags: ["Naval", "学习"]
            )
        ]),
        DailyJournal(date: "2025-11-20", entries: [
            JournalEntry(
                content: "生活中所有真正的收益都来自复利，无论是人际关系、财富还是知识。",
                time: "08:30:00",
                tags: ["Naval", "复利"]
            )
        ])
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                // 1. 自定义顶部导航栏
                HStack {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(Theme.color.foreground)
                    }
                    
                    Spacer()
                    
                    Text("Moki")
                        .font(Theme.font.title3.weight(.bold)) // 使用 Serif 字体更有质感
                        .foregroundColor(Theme.color.foreground)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(Theme.color.foreground)
                    }
                }
                .padding(.horizontal, Theme.spacing.lg)
                .padding(.top, Theme.spacing.md) // 适配灵动岛/刘海
                .padding(.bottom, Theme.spacing.md)
                .background(Theme.color.background)
                
                // 2. 滚动内容区
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(journalData) { day in
                            VStack(spacing: 0) {
                                // 日期头
                                JournalDateHeader(date: day.date)
                                    .padding(.top, Theme.spacing.lg)
                                
                                // 当天的日记条目
                                ForEach(day.entries) { entry in
                                    JournalItemView(
                                        content: entry.content,
                                        time: entry.time,
                                        tags: entry.tags,
                                        images: entry.images
                                    )
                                }
                            }
                        }
                        
                        Spacer(minLength: 100) // 底部留白，防遮挡
                    }
                    .padding(.horizontal, Theme.spacing.lg)
                }
            }
            .background(Theme.color.background)
            
            // 3. 悬浮按钮 (FAB)
            Button(action: {
                // TODO: 新增日记动作
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Theme.color.primaryAction)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .padding(.trailing, Theme.spacing.lg)
            .padding(.bottom, Theme.spacing.lg)
        }
    }
}

#Preview {
    TimelineView()
}

