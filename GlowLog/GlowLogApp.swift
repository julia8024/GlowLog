//
//  GlowLogApp.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI
import SwiftData

@main
struct GlowLogApp: App {
    @AppStorage("appearanceMode") private var appearanceRaw = AppearanceMode.system.rawValue
    
    private var appearance: AppearanceMode {
        AppearanceMode(rawValue: appearanceRaw) ?? .system
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Habit.self)
                .preferredColorScheme(appearance.colorScheme) // 전역 적용
        }
    }
}


// 다크모드 대응만 하면 됨
