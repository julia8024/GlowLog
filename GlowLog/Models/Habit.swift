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
    
    var isArchived: Bool        // 보관 여부
    var archivedAt: Date?       // 보관된 시간
    var deletedAt: Date?         // 삭제된 시간 (3일간 보관)

    init(
        title: String,
        detail: String? = nil,
        createdAt: Date = Date(),
        completedDates: [Date] = [],
        isArchived: Bool = false,
        archivedAt: Date? = nil,
        deletedAt: Date? = nil
    ) {
        self.title = title
        self.detail = detail
        self.createdAt = createdAt
        self.completedDates = completedDates
        self.isArchived = isArchived
        self.archivedAt = archivedAt
        self.deletedAt = deletedAt
    }

    // 완료 토글
    func toggleCompletion(for date: Date) {
        let today = Calendar.current.startOfDay(for: Date())
        let target = Calendar.current.startOfDay(for: date)

        // 미래 날짜면 동작 안 함
        guard target <= today else { return }
        
        // 보관된 습관이면 동작 안 함
        guard !isArchived else { return }

        if let index = completedDates.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: target) }) {
            completedDates.remove(at: index)
        } else {
            completedDates.append(target)
        }
    }

    // 특정 날짜 완료 여부
    func isCompleted(on date: Date) -> Bool {
        return completedDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
    }
    
    // 삭제 상태 확인 (3일 안 지났으면 true)
    var isSoftDeleted: Bool {
        if let deletedAt {
            return Date() < Calendar.current.date(byAdding: .day, value: 3, to: deletedAt)!
        }
        return false
    }

}

extension Habit {
    
    static var nowPredicate: Predicate<Habit> {
        #Predicate<Habit> { habit in
            !habit.isArchived && habit.deletedAt == nil
        }
    }
    
    static var softDeletedPredicate: Predicate<Habit> {
        #Predicate<Habit> { habit in
            habit.deletedAt != nil
        }
    }

    static var archivedPredicate: Predicate<Habit> {
        #Predicate<Habit> { $0.isArchived }
    }
}
