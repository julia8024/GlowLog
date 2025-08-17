//
//  EqualHeightPreferenceKey.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import SwiftUI

struct EqualHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue()) // 가장 큰 높이를 채택
    }
}

