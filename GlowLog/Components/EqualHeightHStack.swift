//
//  EqualHeightHStack.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import SwiftUI

struct EqualHeightHStack<Content: View>: View {
    @State private var maxHeight: CGFloat = 0
    let spacing: CGFloat
    let content: () -> Content

    init(spacing: CGFloat = 10, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        HStack(spacing: spacing) {
            content()
                .measureHeight()
                .frame(height: maxHeight)
        }
        .onPreferenceChange(EqualHeightPreferenceKey.self) { height in
            maxHeight = height
        }
    }
}
