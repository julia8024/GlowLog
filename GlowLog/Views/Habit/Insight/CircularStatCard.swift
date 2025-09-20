//
//  CircularStatCard.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import SwiftUI

struct CircularStatCard: View {
    let title: String
    let progress: Double // 0.0 ~ 1.0
    let value: String
    let hasBorder: Bool?
    
    init(title: String, progress: Double, value: String, hasBorder: Bool? = true) {
        self.title = title
        self.progress = progress
        self.value = value
        self.hasBorder = hasBorder
    }
    
    private var percentText: String {
        "\(Int(progress * 100))%"   // ✅ 내부에서 바로 계산
    }
    
    var body: some View {
        BaseStatCard(title: title, hasBorder: hasBorder ?? true) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color("black"), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text(percentText)
                        .textStyle(.subtitle)
                        .bold()
                }
            }
            .frame(width: 70, height: 70)
            .padding(.bottom, 6)
            
            Text(value)         // "달성/전체"
                .textStyle(.smaller, color: .secondary)
        }
    }
}
