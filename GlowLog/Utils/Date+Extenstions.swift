//
//  Date+Extenstions.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import Foundation

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }
}
