//
//  AddHabitView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var detail: String = ""

    @FocusState private var focusTitle: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("기본 정보") {
                    TextField("제목(필수)", text: $title)
                        .focused($focusTitle)
                        .submitLabel(.done)

                    TextField("설명(선택)", text: $detail, axis: .vertical)
                        .lineLimit(1...4)
                }
            }
            .navigationTitle("새 습관")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear { focusTitle = true }
        }
    }

    private func save() {
        guard let trimmedTitle = title.trimmedOrNil else { return }

        let habit = Habit(
            title: trimmedTitle,
            detail: detail.trimmedOrNil
        )
        
        context.insert(habit)
        dismiss()
    }
}
