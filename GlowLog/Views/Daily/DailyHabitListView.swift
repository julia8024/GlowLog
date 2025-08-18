//
//  DailyHabitListView.swift
//  GlowLog
//
//  Created by 장세희 on 8/18/25.
//

import SwiftUI

struct DailyHabitListView: View {
    
    let selectedDate: Date
    let habits: [Habit]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(habits) { habit in
                    DailyHabitRow(selectedDate: selectedDate, habit: habit)
                }
            }
        }
    }
}
