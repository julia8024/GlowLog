//
//  HabitManager.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import Foundation
import SwiftData



final class HabitManager {
    let freeLimit: Int = 5
    private let repo: HabitRepository

    init(repo: HabitRepository) { self.repo = repo }

    /// 새 습관 추가 가능? (프리미엄이면 무제한, 아니면 보관 포함 총 개수 기준)
    func canAddHabit(hasPremium: Bool) -> Bool {
        guard !hasPremium else { return true }
        let total = (try? repo.totalCountExcludingDeleted()) ?? 0
        return total < freeLimit
    }

    /// 보관 기능은 프리미엄에서만
    func canArchive(hasPremium: Bool) -> Bool {
        hasPremium
    }

    func paywallMessageForAdd() -> String {
        "아직은 습관을 \(freeLimit)개까지만 사용할 수 있어요."
//        프리미엄으로 업그레이드하면 무제한으로 추가할 수 있습니다."
    }
    
    func paywallMessageForArchive() -> String {
        "보관 기능은 프리미엄에서 제공됩니다."
    }

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

enum AddHabitGate {
    static func handleTap(manager: HabitManager,
                          hasPremium: Bool,
                          onAllowed: () -> Void,
                          onBlocked: (_ message: String) -> Void) {
        if manager.canAddHabit(hasPremium: hasPremium) {
            onAllowed()
        } else {
            onBlocked(manager.paywallMessageForAdd())
        }
    }
}
