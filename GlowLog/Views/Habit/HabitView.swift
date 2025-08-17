//
//  HabitView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI
import SwiftData

struct HabitView: View {
    
    @Query(filter: Habit.nowPredicate) var habits: [Habit]
    
    @Query(filter: Habit.archivedPredicate) var archivedHabits: [Habit]
    
    @Query(filter: Habit.softDeletedPredicate) var softDeletedHabits: [Habit]
    
    @State private var showingAddHabit: Bool = false
    @State private var showingArchivedHabit: Bool = false
    @State private var showingSoftDeletedHabit: Bool = false
    
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack (spacing: 10) {
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
                
                Menu {
                    Button {
                        showingArchivedHabit = true
                    } label: {
                        Text("보관된 습관")
                    }

                    Button {
                        showingSoftDeletedHabit = true
                    } label: {
                        Text("최근 삭제된 습관")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .sheet(isPresented: $showingArchivedHabit) {
                    NavigationStack {
                        HabitListView(habits: archivedHabits)
                            .navigationTitle("보관된 습관")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("닫기") {
                                        showingArchivedHabit = false
                                    }
                                }
                            }
                    }
                }
                .sheet(isPresented: $showingSoftDeletedHabit) {
                    NavigationStack {
                        HabitListView(habits: softDeletedHabits)
                            .navigationTitle("삭제된 습관")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("닫기") {
                                        showingSoftDeletedHabit = false
                                    }
                                }
                            }
                    }
                }
            }
            .padding(20)
            
            HabitListView(habits: habits)
            
            Spacer()
            
        }
        
    }
}
