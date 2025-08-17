//
//  HabitInsightView.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//
import SwiftUI

struct HabitInsightView: View {
    
    @State private var equalHeight: CGFloat?

    let year: Int
    let month: Int
    let completedDates: [Date]
    
    private var calendar: Calendar { .current }
    
    private var totalDaysInMonth: Int {
        guard let range = calendar.range(of: .day, in: .month, for: dateForMonth) else { return 0 }
        return range.count
    }
    
    private var completedDaysCount: Int {
        completedDates.count
    }
    
    private var progress: Double {
        totalDaysInMonth > 0 ? Double(completedDaysCount) / Double(totalDaysInMonth) : 0
    }
    
    // 연속 달성일 계산
    private var streakCount: Int {
        let today = Date().startOfDay
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        var streak = 0
        var current: Date

        // completedDates 전부 startOfDay로 정규화
        let normalizedCompleted = Set(completedDates.map { $0.startOfDay })

        if normalizedCompleted.contains(today) {
            streak = 1
            current = yesterday
        } else {
            current = yesterday
        }

        while normalizedCompleted.contains(current) {
            streak += 1
            current = calendar.date(byAdding: .day, value: -1, to: current)!
        }

        return streak
    }
    
    private var dateForMonth: Date {
        let components = DateComponents(year: year, month: month, day: 1)
        return calendar.date(from: components)!
    }
    
    // TO DO : 시간대 계산 - 설정된 타임존에 맞게 계산하도록 수정하기
//    private var mostActiveTimeRangeDescription: String {
//        let hours = completedDates.map { Calendar.current.component(.hour, from: $0) }
//        guard !hours.isEmpty else { return "데이터 없음" }
//        
//        let ranges: [(label: String, range: Range<Int>, emoji: String)] = [
//            ("새벽", 0..<6, "🌙"),
//            ("아침", 6..<12, "☀️"),
//            ("점심", 12..<18, "🌤"),
//            ("저녁", 18..<24, "🌆")
//        ]
//        
//        let counts = ranges.map { r in
//            (label: r.label, count: hours.filter { r.range.contains($0) }.count, emoji: r.emoji)
//        }
//        
//        if let best = counts.max(by: { $0.count < $1.count }) {
//            // 대략적인 범위 (최빈 시간대 좁히고 싶으면 추가 로직 가능)
//            return "\(best.label) \(best.emoji)"
//        }
//        return "데이터 없음"
//    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            EqualHeightCardHStack (spacing: 10) {
                CircularStatCard(
                    title: "달성률",
                    progress: progress,
                    value: "\(completedDaysCount) / \(totalDaysInMonth)",
                    hasBorder: false
                )
                
                
                ProgressIconStatCard(
                    title: "상태",
                    progress: progress,
                    hasBorder: false
                )
            }
            
            // MARK: - TO DO: 시간대 설정 및 다국어(영어/한국어) 지원 시 추가하기
//            EqualHeightCardHStack (spacing: 10) {
//                StatCard(
//                    title: "연속 달성",
//                    value: "\(streakCount)일째",
//                    hasBorder: false
//                )
//                
//                StatCard(
//                    title: "주로 완료하는 시간대",
//                    value: mostActiveTimeRangeDescription,
//                    hasBorder: false
//                )
//            }
            
            // 요일별 분석 카드
            WeekdayBarChartCard(completedDates: completedDates)
            
        }
    }
    
}
