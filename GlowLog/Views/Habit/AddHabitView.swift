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

    // MARK: - Derived
    private var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // Alert 상태 관리
    @State private var showingCancelAlert: Bool = false

    let exampleHabits = [
        "물 3잔 이상 마시기",
        "일어나서 5분 스트레칭하기",
        "자기 전 10분 독서하기"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // 헤더
                    VStack(alignment: .leading, spacing: 10) {
                        Text("새 습관")
                            .textStyle(.headline)
                        Text("짧고 명확하게 적을수록 좋아요")
                            .textStyle(.body, color: .gray)
                            .foregroundStyle(.secondary)
                    }

                    // 제목
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("제목")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                            Text("필수")
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Capsule())
                        }

                        MordenTextField(
                            text: $title,
                            placeholder: "예시) 물 3잔 이상 마시기",
                            isMultiline: false
                        )
                        .focused($focusTitle)
                        .submitLabel(.done)
                    }

                    // 설명
                    VStack(alignment: .leading, spacing: 6) {
                        Text("설명")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)

                        MordenTextField(
                            text: $detail,
                            placeholder: "필요 시 추가로 설명을 작성해요",
                            isMultiline: false
                        )
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("이런 건 어때요?")
                            .textStyle(.title)
                    
                        ForEach(exampleHabits, id: \.self) { example in
                            Button {
                                title = example
                            } label: {
                                Text(example)
                                    .textStyle(.body)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(.gray.opacity(0.3), lineWidth: 1)
                            )
                            
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        if isEditing {
                            showingCancelAlert = true
                        } else {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear { focusTitle = true }
            .alert("입력 중인 데이터가 사라집니다", isPresented: $showingCancelAlert) {
                Button("계속 작성", role: .cancel) {}
                Button("취소", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("그래도 취소하시겠어요?")
            }
        }
    }
    
    private var isEditing: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !detail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Actions
    private func save() {
        let trimmed = title.trimmed
        guard !trimmed.isEmpty else { return }

        let habit = Habit(
            title: trimmed,
            detail: detail.trimmedOrNil
        )
        context.insert(habit)
        dismiss()
    }

    private func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}

