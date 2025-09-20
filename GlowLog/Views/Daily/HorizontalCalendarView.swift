//
//  HorizontalCalendarView.swift
//  GlowLog
//
//  Created by 장세희 on 8/18/25.
//

import SwiftUI

struct HorizontalCalendarView: View {
    @Binding var selectedDate: Date

    // 날짜 스트립 양옆 버퍼(일) — 끝으로 가면 리센터
    var dayWindow: Int = 365
    // 월 바 양옆 버퍼(월)
    var monthWindow: Int = 12

    @State private var dayStrip: [Date] = []
    @State private var monthStarts: [Date] = []
    @State private var currentMonthStart: Date = Date()

    private let cal = Calendar.current

    // Formatters
    private let dayFmt: DateFormatter = { let f = DateFormatter(); f.dateFormat = "d"; return f }()
    private let weekdayFmt: DateFormatter = { let f = DateFormatter(); f.dateFormat = "EE"; return f }()
    private let monthFmtWide: DateFormatter = { let f = DateFormatter(); f.dateFormat = "MMMM"; return f }()

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            monthBarView
                .frame(height: 40)

            dayStripView
                .frame(height: 105)
        }
    }

    // MARK: - Subviews

    /// 월 바 (가로 스크롤) — 월 탭 시 해당 월의 1일로 이동
    private var monthBarView: some View {
        ScrollViewReader { mProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(monthStarts, id: \.self) { mStart in
                        let isCurrent = cal.isDate(mStart, inSameDayAs: currentMonthStart)
                        Text(monthFmtWide.string(from: mStart))
                            .textStyle(.headline)
                            .opacity(isCurrent ? 1.0 : 0.25)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                    let first = firstDay(of: mStart)
                                    selectedDate = first
                                    currentMonthStart = mStart
                                    rebuildDayStrip(center: first)
                                    mProxy.scrollTo(mStart, anchor: .center)
                                }
                            }
                            .id(mStart)
                    }
                }
                .padding(.horizontal, 4)
            }
            .onAppear {
                currentMonthStart = monthStart(for: selectedDate)
                rebuildMonthBar(center: selectedDate)
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        mProxy.scrollTo(currentMonthStart, anchor: .center)
                    }
                }
            }
            .onChange(of: currentMonthStart) { _, newVal in
                withAnimation(.easeInOut(duration: 0.25)) {
                    mProxy.scrollTo(newVal, anchor: .center)
                }
            }
        }
    }

    /// 일자 스트립 (무한처럼 리센터링)
    private var dayStripView: some View {
        ScrollViewReader { dProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(dayStrip, id: \.self) { date in
                        let isSelected = cal.isDate(date, inSameDayAs: selectedDate)
                        let isToday = date.isToday
                        
                        VStack(spacing: 6) {
                            Text(weekdayFmt.string(from: date))
                                .textStyle(.smaller, color: (isSelected ? Color(.secondarySystemBackground) : Color("black")).opacity(0.6))
                            Text(dayFmt.string(from: date))
                                .textStyle(.title, color: isSelected ? Color(.systemBackground) : Color("black"))
                            
                        }
                        .frame(width: 48, height: 80)
                        .background(
                            Group {
                                if isSelected {
                                    Capsule()
                                        .fill(Color("black"))
                                        .shadow(radius: 6, x: 0, y: 3)
                                }
                            }
                        )
                        // 오늘 점: overlay로 바닥에 붙임
                        .overlay(alignment: .bottom) {
                            if isToday {
                                Circle()
                                    .fill(isSelected ? Color(.systemBackground) : Color("black"))
                                    .frame(width: 6, height: 6)
                                    .offset(y: -6) // 살짝 아래로 내리고 싶으면 조절
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedDate = date
                                dProxy.scrollTo(cal.startOfDay(for: date), anchor: .center)
                            }
                        }
                        .id(cal.startOfDay(for: date))
                    }
                }
                .padding(.horizontal, 2)
            }
            .onAppear {
                rebuildDayStrip(center: selectedDate)
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        dProxy.scrollTo(cal.startOfDay(for: selectedDate), anchor: .center)
                    }
                }
            }
            .onChange(of: selectedDate) { _, newVal in
                // 월/월바 동기화
                let newMonth = monthStart(for: newVal)
                if newMonth != currentMonthStart {
                    currentMonthStart = newMonth
                    rebuildMonthBar(center: newVal)
                }
                // 끝 가까우면 리센터
                recenterIfNeeded(around: newVal, dProxy: dProxy)
                withAnimation(.easeInOut(duration: 0.25)) {
                    dProxy.scrollTo(cal.startOfDay(for: newVal), anchor: .center)
                }
            }
        }
    }

    // MARK: - Recenter logic
    private func recenterIfNeeded(around date: Date, dProxy: ScrollViewProxy) {
        guard let idx = dayStrip.firstIndex(where: { cal.isDate($0, inSameDayAs: date) }) else { return }
        let threshold = 30
        if idx < threshold || idx > dayStrip.count - threshold {
            rebuildDayStrip(center: date)
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.25)) {
                    dProxy.scrollTo(cal.startOfDay(for: date), anchor: .center)
                }
            }
        }
    }

    // MARK: - Builders
    private func rebuildDayStrip(center: Date) {
        let c = cal.startOfDay(for: center)
        let start = cal.date(byAdding: .day, value: -dayWindow, to: c) ?? c
        let end   = cal.date(byAdding: .day, value:  dayWindow, to: c) ?? c
        dayStrip = dates(from: start, to: end)
    }

    private func rebuildMonthBar(center: Date) {
        let mid = monthStart(for: center)
        monthStarts = (-monthWindow...monthWindow).compactMap { off in
            guard let m = cal.date(byAdding: .month, value: off, to: mid) else { return nil }
            return monthStart(for: m)
        }
    }

    // MARK: - Helpers
    private func monthStart(for date: Date) -> Date {
        cal.date(from: cal.dateComponents([.year, .month], from: date)) ?? date
    }
    private func firstDay(of monthStart: Date) -> Date {
        monthStart
    }
    private func dates(from start: Date, to end: Date) -> [Date] {
        var res: [Date] = []
        var cur = start
        while cur <= end {
            res.append(cur)
            cur = cal.date(byAdding: .day, value: 1, to: cur) ?? cur
            if cur == res.last { break }
        }
        return res
    }
}
