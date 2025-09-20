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
    @Environment(\.dismiss) private var dismiss
    
//    @State private var habitManager: HabitManager?
    
    @State private var selectedDate: Date? = nil
    @State private var currentMonth: Date = Date()
    
    @State private var isEditingTitle = false
    @State private var tempTitle: String = ""
    
    @State private var isEditingDetail = false
    @State private var tempDetail: String = ""
    
    // alert 통합
    private enum AppAlert: Identifiable {
        case dateSelected(date: Date, completed: Bool)
        case editingConflict(isTitleEditing: Bool)

        var id: String {
            switch self {
            case .dateSelected:          return "dateSelected"
            case .editingConflict:       return "editingConflict"
            }
        }
    }
    @State private var activeAlert: AppAlert?
    
    @FocusState private var focusedField: Field?

    enum Field {
        case title
        case detail
    }
    
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
    
    // 현재 연도 / 월
    private var currentYear: Int {
        calendar.component(.year, from: currentMonth)
    }
    private var currentMonthInt: Int {
        calendar.component(.month, from: currentMonth)
    }
    
    // 이번 달에 완료한 날짜들만 뽑기
    private var completedDatesThisMonth: [Date] {
        habit.completedDates.filter { date in
            calendar.component(.year, from: date) == currentYear &&
            calendar.component(.month, from: date) == currentMonthInt
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                if habit.isArchived {
                    Label("\(habit.archivedAt!.koreanFullFormat)에 보관됨", systemImage: "archivebox")
                        .textStyle(.body)
                }
                // 제목
                if isEditingTitle {
                    TextField("제목을 입력하세요", text: $tempTitle)
                        .textFieldStyle(.plain)
                        .textStyle(.title)
                        .focused($focusedField, equals: .title)
                        .onAppear {
                            tempTitle = habit.title
                            focusedField = .title
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("취소") {
                                    isEditingTitle = false
                                    focusedField = nil
                                }
                                Spacer()
                                Button("저장") {
                                    habit.title = tempTitle
                                    isEditingTitle = false
                                    focusedField = nil
                                }
                                .bold()
                                .disabled(tempTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                        }
                } else {
                    Text(habit.title)
                        .textStyle(.title)
                        .onTapGesture {
                            if isEditingDetail {
                                activeAlert = .editingConflict(isTitleEditing: false)
                            } else {
                                isEditingTitle = true
                                tempTitle = habit.title
                            }
                        }
                }

                // 설명
                if isEditingDetail {
                    TextField("설명을 입력하세요", text: $tempDetail, axis: .vertical)
                        .textFieldStyle(.plain)
                        .textStyle(.body)
                        .focused($focusedField, equals: .detail)
                        .onAppear {
                            tempDetail = habit.detail ?? ""
                            focusedField = .detail
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("취소") {
                                    isEditingDetail = false
                                    focusedField = nil
                                }
                                Spacer()
                                Button("저장") {
                                    habit.detail = tempDetail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                        ? nil
                                        : tempDetail
                                    isEditingDetail = false
                                    focusedField = nil
                                }
                                .bold()
                            }
                        }
                } else {
                    if let detail = habit.detail, !detail.isEmpty {
                        Text(detail)
                            .textStyle(.body, color: .secondary)
                            .onTapGesture {
                                if isEditingTitle {
                                    activeAlert = .editingConflict(isTitleEditing: true)
                                } else {
                                    isEditingDetail = true
                                    tempDetail = detail
                                }
                            }
                    } else {
                        Button {
                            if isEditingTitle {
                                activeAlert = .editingConflict(isTitleEditing: true)
                            } else {
                                isEditingDetail = true
                                tempDetail = ""
                            }
                        } label: {
                            Label("설명추가", systemImage: "pencil.line")
                                .textStyle(.body, color: .secondary)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            ScrollView {
                VStack {
                    // 상단 월/년도 이동
                    HStack {
                        Button { changeMonth(by: -1) } label: {
                            Image(systemName: "chevron.left")
                        }
                        Spacer()
                        Text(monthTitle(currentMonth))
                            .textStyle(.subtitle)
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
                            let isFuture = day.startOfDay > Date().startOfDay
                            
                            Text("\(calendar.component(.day, from: day))")
                                .textStyle(.small, color:
                                    isFuture ? .secondary :
                                            (completed ? Color(.systemBackground) : .primary)
                                )
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(
                                            isSelected ? Color.gray.opacity(0.2) :
                                                (completed ? .primary : Color(.systemBackground))
                                        )
                                )
                                .onTapGesture {
                                    // 선택한 날짜가 미래인 경우 || 해당 습관이 보관상태인 경우에는 선택 막기
                                    if isFuture || habit.isArchived || habit.deletedAt != nil {
                                        return // 막기
                                    }
                                    let dayStart = day.startOfDay
                                    selectedDate = dayStart
                                    activeAlert = .dateSelected(date: dayStart,
                                                            completed: habit.isCompleted(on: dayStart))
                                }
                        }
                    }
                }
                .padding(.bottom, 20)
                
                // 통계
                HabitInsightView(
                    year: currentYear,
                    month: currentMonthInt,
                    completedDates: completedDatesThisMonth
                )
            }
            .scrollIndicators(.hidden)
            
            Spacer()
            
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    if habit.deletedAt == nil {
                        // MARK: - 보관기능
//                        Button {
//                            habit.isArchived.toggle()
//                            habit.archivedAt = Date()
//                        } label: {
//                            Label(habit.isArchived ? "보관 해제" : "보관", systemImage: "archivebox")
//                        }
                        
                        Button(role: .destructive) {
                            habit.deletedAt = Date() // soft delete
                            dismiss()
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    } else {
                        Button {
                            habit.deletedAt = nil
                            dismiss()
                        } label: {
                            Label("복구", systemImage: "arrow.counterclockwise")
                        }
                        
                        Button(role: .destructive) {
                            context.delete(habit)
                            dismiss()
                        } label: {
                            Label("영구 삭제", systemImage: "trash")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
//        .onAppear {
//            if habitManager == nil {
//                 let repo = SwiftDataHabitRepository(context: context)
//                 habitManager = HabitManager(repo: repo)
//            }
//        }
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .editingConflict(let isTitleEditing):
                return Alert(
                    title: Text("\(isTitleEditing ? "제목을" : "설명을") 작성중이에요"),
                    message: Text("저장 후 시도해주세요"),
                    dismissButton: .default(Text("확인"))
                )
                
            case .dateSelected(let date, let completed):
                if completed {
                    return Alert(
                        title: Text("이미 완료로 기록했어요"),
                        message: Text("\(date.koreanFullFormat)의 습관 기록을 지우시겠어요?"),
                        primaryButton: .destructive(Text("기록 지우기")) {
                            withAnimation { habit.toggleCompletion(for: date) }
                            selectedDate = nil
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                } else {
                    return Alert(
                        title: Text("오늘의 습관을 달성했나요?"),
                        message: Text("\(date.koreanFullFormat)의 습관을 완료로 기록할까요?"),
                        primaryButton: .default(Text("기록하기")) {
                            withAnimation { habit.toggleCompletion(for: date) }
                            selectedDate = nil
                        },
                        secondaryButton: .cancel(Text("취소"))
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
        formatter.dateFormat = "yyyy년 MM월"
        return formatter.string(from: date)
    }
}
