//
//  BaseStatCard.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import SwiftUI

struct BaseStatCard<Content: View>: View {
    let title: String
    let hasBorder: Bool
    let content: () -> Content
    
    init(title: String, hasBorder: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.hasBorder = hasBorder
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .textStyle(.small, color: .secondary)
            
            content()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 15)
        .padding(.horizontal)
        .padding(.bottom)
        .overlay {
            if hasBorder {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.secondary.opacity(0.4), lineWidth: 1)
            }
        }
    }
}
