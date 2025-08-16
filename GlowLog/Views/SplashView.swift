//
//  SplashView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//


import SwiftUI

struct SplashView: View {
    
    var body: some View {
        VStack {
            VStack {
                Image("AppIconForSplash")
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .clipped()
                    .padding(.horizontal, 140)
                    .padding(.bottom, 80)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SplashView()
}
