//
//  WeekdayBarChartCard.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import SwiftUI

struct WeekdayBarChartCard: View {
    let completedDates: [Date]
    
    private let calendar = Calendar.current
    
    private var weekdayCounts: [Int] {
        let weekdays = completedDates.map { calendar.component(.weekday, from: $0) }
        return (1...7).map { day in
            weekdays.filter { $0 == day }.count
        }
    }
    
    private let weekdaySymbols = ["일", "월", "화", "수", "목", "금", "토"]
    
    private var maxValue: Int {
        weekdayCounts.max() ?? 0
    }
    
    var body: some View {
        BaseStatCard(title: "요일별 분석") {
            HStack(alignment: .bottom, spacing: 20) {
                ForEach(0..<7, id: \.self) { index in
                    VStack {
                        // 막대
                        RoundedRectangle(cornerRadius: 10)
                            .fill(weekdayCounts[index] == maxValue && maxValue > 0 ? Color.primary : Color.gray.opacity(0.4))
                            .frame(height: maxValue > 0 ? CGFloat(weekdayCounts[index]) * 20 : 0) // y값 스케일
                            .frame(maxWidth: 16)
                        
                        // 요일 라벨
                        Text(weekdaySymbols[index])
                            .textStyle(.small, color: .gray)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120)
        }
    }
}
