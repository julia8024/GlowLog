//
//  ContentView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//
import SwiftUI

struct ContentView: View {
    @State var isLaunching: Bool = true
        
    var body: some View {
        if isLaunching {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isLaunching = false
                    }
                }
        } else {
            BottomTabView()
        }
    }
}

#Preview {
    ContentView()
}
