//
//  DailyHabitRow.swift
//  GlowLog
//
//  Created by 장세희 on 8/18/25.
//

import SwiftUI

struct DailyHabitRow: View {

    let selectedDate: Date
    let habit: Habit
    
    private var isCompleted: Bool {
        habit.completedDates.contains { $0.isSameDay(as: selectedDate) }
    }

    var body: some View {

        
        HStack {
            Button {
                habit.toggleCompletion(for: selectedDate)
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundStyle(isCompleted ? .primary : Color.gray.opacity(0.4))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.title)
                            .textStyle(.subtitle, color: .primary)
                        
                        if let detail = habit.detail, !detail.isEmpty {
                            Text(detail)
                                .textStyle(.small, color: .secondary)
                        }
                    }
                    
                    Spacer()
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .disabled(habit.isArchived || selectedDate.isFuture)
                
            NavigationLink(destination: HabitDetailView(habit: habit)) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20))
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 5)
            }

        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.secondary.opacity(0.4), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    
}
