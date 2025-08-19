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
    @Query(filter: Habit.nowPredicate) var habits: [Habit]
    
    @Query(filter: Habit.archivedPredicate) var archivedAllHabits: [Habit]
    
    @State private var selectedDate = Date() // 기본: 오늘
    
    /// 선택한 날짜(당일 포함)보다 "미래 또는 동일"에 보관된 것만 보여줌: archivedAt ≥ selectedDay
    private var archivedHabits: [Habit] {
        let cal = Calendar.current
        return archivedAllHabits.filter { h in
            guard let a = h.archivedAt else { return false }
            return cal.startOfDay(for: a) >= selectedDate.startOfDay
        }
    }
    
    var body: some View {
        if habits.isEmpty {
            EmptyHabitView()
        } else {
            VStack(alignment: .leading, spacing: 20) {

                
                HorizontalCalendarView(selectedDate: $selectedDate,
                                       dayWindow: 365,
                                       monthWindow: 3)
                
                HStack (spacing: 6) {
                    if selectedDate.isToday {
                        Text("TODAY")
                            .textStyle(.subtitle)
                    }
                    Text("\(selectedDate.koreanFullFormat)")
                        .textStyle(.small, color: .secondary)
                }
                
                
                DailyHabitListView(selectedDate: selectedDate, habits: habits)
                
                // MARK: - 보관기능
//                if !archivedHabits.isEmpty {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Label("보관된 습관", systemImage: "archivebox")
//                            .textStyle(.subtitle)
//                        DailyHabitListView(selectedDate: selectedDate, habits: archivedHabits)
//                    }
//                }
                
                Spacer()
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
    }
}
