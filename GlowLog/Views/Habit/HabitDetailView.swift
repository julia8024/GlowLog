//
//  HabitDetailView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @State private var selectedDate = Date()

    var body: some View {
        VStack(spacing: 20) {
            Text(habit.title)
                .textStyle(.headline)
            
            if let detail = habit.detail, !detail.isEmpty {
                Text(detail)
                    .textStyle(.description)
            }

            DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)

            Button(action: {
                habit.toggleCompletion(for: selectedDate)
            }) {
                Text(habit.isCompleted(on: selectedDate) ? "완료 취소" : "완료하기")
                    .padding()
                    .background(habit.isCompleted(on: selectedDate) ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            List {
                ForEach(habit.completedDates, id: \.self) { date in
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                }
            }
        }
        .padding()
    }
}
