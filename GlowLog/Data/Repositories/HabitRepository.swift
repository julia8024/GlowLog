//
//  HabitRepository.swift
//  GlowLog
//
//  Created by 장세희 on 8/18/25.
//
import SwiftUI
import SwiftData

protocol HabitRepository {
    func totalCountExcludingDeleted() throws -> Int   // 보관 포함, 삭제 제외
    func activeCount() throws -> Int                  // (옵션) 활성만
}

final class SwiftDataHabitRepository: HabitRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }

    func totalCountExcludingDeleted() throws -> Int {
        let predicate = #Predicate<Habit> { $0.deletedAt == nil }
        var desc = FetchDescriptor<Habit>(predicate: predicate)
        desc.fetchLimit = 1_000_000 // SwiftData엔 count 전용이 없어 대략 제한
        return try context.fetch(desc).count
    }

    func activeCount() throws -> Int {
        let predicate = #Predicate<Habit> { $0.deletedAt == nil && $0.isArchived == false }
        var desc = FetchDescriptor<Habit>(predicate: predicate)
        desc.fetchLimit = 1_000_000
        return try context.fetch(desc).count
    }
}
