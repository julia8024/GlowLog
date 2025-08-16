//
//  Habit.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//


import Foundation
import SwiftData
@Model
class Habit {
    var title: String // 제목
    var detail: String? // 설명
    var createdAt: Date
    var completedDates: [Date]

    init(title: String, detail: String? = nil, createdAt: Date = Date(), completedDates: [Date] = []) {
        self.title = title
        self.detail = detail
        self.createdAt = createdAt
        self.completedDates = completedDates
    }

    func toggleCompletion(for date: Date) {
        if let index = completedDates.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
            completedDates.remove(at: index)
        } else {
            completedDates.append(date)
        }
    }

    func isCompleted(on date: Date) -> Bool {
        return completedDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
    }
}
