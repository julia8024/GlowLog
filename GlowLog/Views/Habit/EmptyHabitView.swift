//
//  EmptyHabitView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI
import SwiftData

struct EmptyHabitView: View {
    @Environment(\.modelContext) private var context
    
    @State private var showingAddHabit: Bool = false

    var body: some View {
        VStack (spacing: 30) {
            Text("습관을 추가해보세요")
                .textStyle(.title)
            
            Button {
                showingAddHabit = true
            } label: {
                Label("습관 추가하기", systemImage: "plus")
                    .textStyle(.body)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain) // 기본 버튼 스타일
            .buttonBorderShape(.roundedRectangle(radius: 30))
            .padding(15)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(.primary, lineWidth: 1)
                    
            )
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
        }
        .padding(.horizontal, 20)
    }
}
