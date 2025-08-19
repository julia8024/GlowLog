//
//  HabitListRow.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI

struct HabitListRow: View {
    let habit: Habit
    
    private let calendar = Calendar.current
    
    // 이번 달의 모든 날짜
    private var daysInMonth: [Date] {
        let today = Date().startOfDay
        guard let monthRange = calendar.range(of: .day, in: .month, for: today),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: today))
        else { return [] }
        
        return monthRange.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: monthStart)
        }
    }
    
    // 이번 달 시작 요일 보정 (앞에 비어있는 칸)
    private var leadingEmptyDays: Int {
        let today = Date()
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) else {
            return 0
        }
        let weekday = calendar.component(.weekday, from: monthStart) // 1 = Sunday
        return weekday - 1 // Sunday 시작을 기준으로 빈칸 개수
    }
    
    private let daySymbols = ["S","M","T","W","T","F","S"] // 요일 헤더
    
    // 이번 달 완료 개수
    private var completedCount: Int {
        daysInMonth.filter { habit.isCompleted(on: $0) }.count
    }
    
    
    // 오늘 완료 여부
    private var isTodayCompleted: Bool {
        habit.isCompleted(on: Date())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 습관 제목
            Text(habit.title)
                .textStyle(.subtitle)
                .lineLimit(1)
            
            // 요일 헤더
            HStack(spacing: 6) {
                ForEach(daySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 달력 도트
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 7), spacing: 6) {
                
                // 앞쪽 빈 칸
                ForEach(0..<leadingEmptyDays, id: \.self) { _ in
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 10, height: 10)
                }
                
                // 날짜별 원
                ForEach(daysInMonth, id: \.self) { day in
                    Circle()
                        .fill(habit.isCompleted(on: day) ? Color.primary : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }
            
            // 통계
            HStack {
                // 완료한 일 수 / 전체 일 수
                Text("\(completedCount) / \(daysInMonth.count)")
                    .textStyle(.description)
                
                Spacer()
                
                Label("오늘", systemImage: isTodayCompleted ? "checkmark.circle" : "circle")
                    .labelStyle(.titleFirst)
                    .textStyle(isTodayCompleted ? .small : .description)
                
            }
        }
        .padding(15)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.secondary.opacity(0.4), lineWidth: 1)
        )
    }
}
