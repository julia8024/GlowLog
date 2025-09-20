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
    case smaller
    case description
}

// ViewModifier
struct AppTextStyle: ViewModifier {
    let style: TextStyle
    var color: Color? = nil

    func body(content: Content) -> some View {
        switch style {
        case .headline:
            content
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(color ?? Color("black"))
        case .title:
            content
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(color ?? Color("black"))

        case .subtitle:
            content
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color ?? Color("black"))
            
        case .body:
            content
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(color ?? Color("black"))

        case .small:
            content
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(color ?? Color("black"))
        
        case .smaller:
            content
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(color ?? Color("black"))
            
        case .description:
            content
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
        
        }
    }
}

// View Extension
extension View {
    func textStyle(_ style: TextStyle, color: Color? = nil) -> some View {
        modifier(AppTextStyle(style: style, color: color))
    }
}


/** HOW TO USE
 * Text("습관 이름")
 *      .textStyle(.title)
 */
