//
//  HabitListView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Habit.createdAt, order: .reverse) private var habits: [Habit]


    // 2열 레이아웃 정의
        private let columns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]

    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(habits) { habit in
                    NavigationLink(destination: HabitDetailView(habit: habit)) {
                        HabitListRow(habit: habit)
                    }
                }
                .onDelete(perform: deleteHabit)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }


    private func deleteHabit(at offsets: IndexSet) {
        for index in offsets {
            context.delete(habits[index])
        }
    }
}
