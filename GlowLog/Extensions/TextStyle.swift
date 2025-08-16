//
//  TextStyle.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI

// 사용할 스타일 정의
enum TextStyle {
    case headline
    case title
    case subtitle
    case body
    case small
    case description
}

// ViewModifier
struct AppTextStyle: ViewModifier {
    let style: TextStyle

    func body(content: Content) -> some View {
        switch style {
        case .headline:
            content
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
        case .title:
            content
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)

        case .subtitle:
            content
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            
        case .body:
            content
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.primary)

        case .small:
            content
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.primary)
        
        case .description:
            content
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
        
        }
    }
}

// View Extension
extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.modifier(AppTextStyle(style: style))
    }
}


/** HOW TO USE
 * Text("습관 이름")
 *      .textStyle(.title)
 */
