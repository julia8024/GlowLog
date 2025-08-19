//
//  MordenTextField.swift
//  GlowLog
//
//  Created by 장세희 on 8/18/25.
//
import SwiftUI

struct MordenTextField: View {
    @Binding var text: String
    var placeholder: String
    var isMultiline: Bool = false
    var maxLines: Int = 1

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundStyle(Color.secondary.opacity(0.6))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
            }

            if isMultiline {
                TextEditor(text: $text)
                    .frame(minHeight: 44, maxHeight: CGFloat(maxLines) * 24 + 24)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.clear)
                    .focused($isFocused)
            } else {
                TextField("", text: $text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .focused($isFocused)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isFocused ? Color.primary : Color.primary.opacity(0.15), lineWidth: isFocused ? 1.2 : 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}
