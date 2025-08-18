//
//  HabitView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI
import SwiftData

struct HabitView: View {
    @Environment(\.modelContext) private var context
    
    @Query(filter: Habit.nowPredicate) var habits: [Habit]
    
    @Query(filter: Habit.archivedPredicate) var archivedHabits: [Habit]
    
    @Query(filter: Habit.softDeletedPredicate) var softDeletedHabits: [Habit]
    
    @State private var habitManager: HabitManager?
    
    @State private var showingAddHabit: Bool = false
    @State private var showingArchivedHabit: Bool = false
    @State private var showingSoftDeletedHabit: Bool = false
    
    
    @State private var showingAlert: Bool = false // 무료 습관 개수 제한 메시지 alert
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack (spacing: 10) {
                Text("습관 관리")
                    .textStyle(.headline)
            
                Spacer()
                
                Button {
                    guard let manager = habitManager else { return }
                    AddHabitGate.handleTap(manager: manager,
                                           hasPremium: false,
                                           onAllowed: { showingAddHabit = true },
                                           onBlocked: { msg in alertMessage = msg; showingAlert = true })
                } label: {
                    Label("추가", systemImage: "plus")
                        .textStyle(.body)
                }
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
                
                Menu {
                    // MARK: - 보관기능
//                    Button {
//                        showingArchivedHabit = true
//                    } label: {
//                        Text("보관된 습관")
//                    }

                    Button {
                        showingSoftDeletedHabit = true
                    } label: {
                        Text("최근 삭제된 습관")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                // MARK: - 보관기능
//                .sheet(isPresented: $showingArchivedHabit) {
//                    NavigationStack {
//                        HabitListView(habits: archivedHabits)
//                            .navigationTitle("보관된 습관")
//                            .navigationBarTitleDisplayMode(.inline)
//                            .toolbar {
//                                ToolbarItem(placement: .cancellationAction) {
//                                    Button("닫기") {
//                                        showingArchivedHabit = false
//                                    }
//                                }
//                            }
//                    }
//                }
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
        .onAppear {
            if habitManager == nil {
                 let repo = SwiftDataHabitRepository(context: context)
                 habitManager = HabitManager(repo: repo)
            }
        }
        
    }
}
