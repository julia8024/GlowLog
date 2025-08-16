//
//  DailyCheckView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI
import SwiftData

struct DailyCheckView: View {
    
    @Environment(\.modelContext) private var context
    @Query(sort: \Habit.createdAt, order: .reverse) private var habits: [Habit]
    
    var body: some View {
        if habits.isEmpty {
            EmptyHabitView()
        } else {
            List {
                ForEach(habits) { habit in
                    NavigationLink(destination: HabitDetailView(habit: habit)) {
                        Text(habit.title)
                    }
                }
            }
        }
    }
}
