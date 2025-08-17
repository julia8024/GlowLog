//
//  View+Measure.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import SwiftUI

extension View {
    func measureHeight() -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: EqualHeightPreferenceKey.self,
                                value: proxy.size.height)
            }
        )
    }
}
