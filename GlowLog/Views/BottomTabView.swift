//
//  BottomTabView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI

struct BottomTabView: View {
    private enum Tabs {
        case Daily, Habits, Settings
    }
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        UITabBar.appearance().backgroundColor = .systemBackground
        UITabBar.appearance().standardAppearance = appearance
    }

    @State private var selectedTab: Tabs = .Daily
    
    @StateObject private var timeOfDay = TimeOfDay()
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                DailyCheckView()
                    .tag(Tabs.Daily)
                    .tabItem({
                        Image(systemName: selectedTab == .Daily ?
                              (timeOfDay.isMorning ? "sun.max.fill" : "moon.fill") // 선택된 탭인 경우
                              : (timeOfDay.isMorning ? "sun.max" : "moon"))
                            .environment(\.symbolVariants, .none)
                        Text("오늘의 습관")
                    })
                HabitView()
                    .tag(Tabs.Habits)
                    .tabItem({
                        Image(systemName: selectedTab == .Habits ? "xmark.triangle.circle.square.fill" : "xmark.triangle.circle.square")
                            .environment(\.symbolVariants, .none)
                        Text("습관")
                    })
                SettingView()
                    .tag(Tabs.Settings)
                    .tabItem({
                        Image(systemName: selectedTab == .Settings ? "gearshape.fill" : "gearshape")
                            .environment(\.symbolVariants, .none)
                        Text("설정")
                    })
            }
            .accentColor(.accentColor)
        }
    }
}
