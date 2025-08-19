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
    @State private var habitManager: HabitManager?
    
    @State private var showingAddHabit: Bool = false
    
    @State private var showingAlert: Bool = false // 무료 습관 개수 제한 메시지 alert
    @State private var alertMessage: String = ""

    var body: some View {
        VStack (spacing: 30) {
            Text("습관을 추가해보세요")
                .textStyle(.title)
            
            Button {
                guard let manager = habitManager else { return }
                AddHabitGate.handleTap(manager: manager,
                                       hasPremium: false,
                                       onAllowed: { showingAddHabit = true },
                                       onBlocked: { msg in alertMessage = msg; showingAlert = true })
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
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("안내"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            if habitManager == nil {
                 let repo = SwiftDataHabitRepository(context: context)
                 habitManager = HabitManager(repo: repo)
            }
        }
    }
}
