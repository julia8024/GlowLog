//
//  StatCard.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let hasBorder: Bool?
    
    init(title: String, value: String, hasBorder: Bool? = true) {
        self.title = title
        self.value = value
        self.hasBorder = hasBorder
    }
    
    var body: some View {
        BaseStatCard(title: title, hasBorder: hasBorder ?? true) {
            Text(value)
                .textStyle(.subtitle)
        }
    }
}
