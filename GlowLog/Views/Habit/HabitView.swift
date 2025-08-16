//
//  HabitView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI

struct HabitView: View {
    
    @State private var showingAddHabit = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("습관 관리")
                    .textStyle(.headline)
            
                Spacer()
                
                Button {
                    showingAddHabit = true
                } label: {
                    Label("추가", systemImage: "plus")
                        .textStyle(.body)
                }
                .sheet(isPresented: $showingAddHabit) {
                    AddHabitView()
                }
            }
            .padding(20)
            
            HabitListView()
            
            Spacer()
            
        }
        
    }
}
