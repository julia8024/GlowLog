//
//  EmptyHabitView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI
import SwiftData

struct EmptyHabitView: View {
    
    @State private var showingAddHabit: Bool = false
    
    var body: some View {
        VStack (spacing: 20) {
            Text("습관을 추가해보세요")
                .textStyle(.description)
            
            Button {
                showingAddHabit = true
            } label: {
                Label("습관 추가하기", systemImage: "plus")
                    .textStyle(.body)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered) // 기본 버튼 스타일
            .buttonBorderShape(.roundedRectangle(radius: 30))
            .tint(.primary)
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
        }
    }
}
