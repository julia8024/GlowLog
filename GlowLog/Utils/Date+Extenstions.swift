//
//  Date+Extenstions.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import Foundation

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
    
    /// 오늘 이후(미래) 날짜인지 여부
    var isFuture: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return self.startOfDay > today
    }
    
}
