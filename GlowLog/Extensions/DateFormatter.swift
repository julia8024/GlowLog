//
//  DateFormatter.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import Foundation

extension Date {
    var koreanFullFormat: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
}
