//
//  HabitManager.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import Foundation
import SwiftData

struct HabitManager {
    
    // 삭제된 지 3일 지난 습관들을 DB에서 완전히 제거
    static func cleanupOldDeletedHabits(context: ModelContext) {
        do {
            let allHabits = try context.fetch(FetchDescriptor<Habit>())
            let expired = allHabits.filter { habit in
                if let deletedAt = habit.deletedAt {
                    return deletedAt < Date().addingTimeInterval(-3 * 24 * 60 * 60)
                }
                return false
            }
            
            for habit in expired {
                context.delete(habit)
            }
            
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Cleanup failed:", error.localizedDescription)
        }
    }
}
