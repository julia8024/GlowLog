//
//  TimeOfDay.swift
//  GlowLog
//
//  Created by 장세희 on 8/18/25.
//

import SwiftUI
import Combine

final class TimeOfDay: ObservableObject {
    @Published var isMorning: Bool = TimeOfDay.computeIsMorning()
    private var cancellable: AnyCancellable?

    init() {
        // 매 1시간마다 갱신
        cancellable = Timer.publish(every: 3600, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                self.isMorning = TimeOfDay.computeIsMorning()
            }
        // 첫 진입 시 계산
        self.isMorning = TimeOfDay.computeIsMorning()
    }

    private static func computeIsMorning() -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return (6..<18).contains(hour) // 06:00 ~ 17:59 아침
    }
}
