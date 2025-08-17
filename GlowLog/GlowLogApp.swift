//
//  GlowLogApp.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI
import SwiftData

@main
struct GlowLogApp: App {
    
    @Environment(\.modelContext) private var context

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Habit.self)
                .onAppear {
                    HabitManager.cleanupOldDeletedHabits(context: context)
                }
        }
    }
}
