//
//  HabitDetailView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//
import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @Environment(\.modelContext) private var context
    
    @State private var selectedDate: Date? = nil
    @State private var currentMonth: Date = Date()
    @State private var showingAlert = false
    
    private let calendar = Calendar.current
    
    // 이번 달 범위
    private var monthRange: Range<Date> {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)),
              let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart)
        else { return Date()..<Date() }
        return monthStart..<calendar.date(byAdding: .day, value: 1, to: monthEnd)!
    }
    
    // 이번 달 모든 날짜
    private var daysInMonth: [Date] {
        var days: [Date] = []
        var current = monthRange.lowerBound
        while current < monthRange.upperBound {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        return days
    }
    
    // 이번 달 시작 요일
    private var leadingEmptyDays: Int {
        let monthStart = monthRange.lowerBound
        let weekday = calendar.component(.weekday, from: monthStart) // 1 = Sunday
        return weekday - 1
    }
    
    private let daySymbols = ["S","M","T","W","T","F","S"]
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(habit.title)
                .textStyle(.headline)
            
            if let detail = habit.detail, !detail.isEmpty {
                Text(detail)
                    .textStyle(.description)
            }
            
            VStack {
                // 상단 월/년도 이동
                HStack {
                    Button { changeMonth(by: -1) } label: {
                        Image(systemName: "chevron.left")
                    }
                    Spacer()
                    Text(monthTitle(currentMonth))
                        .font(.headline)
                    Spacer()
                    Button { changeMonth(by: 1) } label: {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
            
                // 달력
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 7), spacing: 6) {
                    
                    // 요일 헤더
                    ForEach(Array(daySymbols.enumerated()), id: \.offset) { index, symbol in
                        Text(symbol)
                            .textStyle(.small)
                            .frame(width: 32, height: 32)
                    }
                    
                    // 앞쪽 빈칸
                    ForEach(0..<leadingEmptyDays, id: \.self) { _ in
                        Color.clear.frame(width: 32, height: 32)
                    }
                    
                    // 날짜 셀
                    ForEach(daysInMonth, id: \.self) { day in
                        let completed = habit.isCompleted(on: day)
                        let isSelected = selectedDate == day.startOfDay
                        
                        Text("\(calendar.component(.day, from: day))")
                            .textStyle(.small, color: isSelected || completed ? .white : .primary)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(
                                        isSelected ? Color.gray.opacity(0.2) :
                                            (completed ? .primary : .white)
                                    )
                            )
                            .onTapGesture {
                                selectedDate = day.startOfDay
                                showingAlert = true
                            }
                    }
                }
                
                
                
                Spacer()
            }
            .padding(.horizontal, 20)
            // Alert 표시
            .alert(isPresented: $showingAlert) {
                guard let date = selectedDate else {
                    return Alert(title: Text("오류"), message: Text("날짜가 선택되지 않았어요"))
                }
                let completed = habit.isCompleted(on: date)
                
                if completed {
                    return Alert(
                        title: Text("이미 완료로 기록했어요"),
                        message: Text("\(date.koreanFullFormat)의 습관 기록을 지우시겠어요?"),
                        primaryButton: .destructive(Text("기록 지우기")) {
                            withAnimation {
                                habit.toggleCompletion(for: date)
                                selectedDate = nil
                            }
                        },
                        secondaryButton: .cancel(Text("취소").foregroundStyle(.gray))
                    )
                } else {
                    return Alert(
                        title: Text("오늘의 습관을 달성했나요?"),
                        message: Text("\(date.koreanFullFormat)의 습관을 완료로 기록할까요?"),
                        primaryButton: .default(Text("기록하기")) {
                            withAnimation {
                                habit.toggleCompletion(for: date)
                                selectedDate = nil
                            }
                        },
                        secondaryButton: .cancel(Text("취소").foregroundStyle(.gray))
                    )
                }
            }
        }
    }
    
    // 월 이동
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
            selectedDate = nil
        }
    }
    
    private func monthTitle(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MMMM"
        return formatter.string(from: date)
    }
}
