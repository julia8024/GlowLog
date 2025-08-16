//
//  LabelStyle.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import SwiftUI

struct TitleFirstLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TitleFirstLabelStyle {
    static var titleFirst: TitleFirstLabelStyle { TitleFirstLabelStyle() }
}
