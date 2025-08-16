//
//  String+Extensions.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import Foundation

extension String {
    /// 앞뒤 공백·개행 제거
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 문자열이 비어있으면 nil 반환, 아니면 그대로 반환
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }

    /// 공백 제거 후 비어있으면 nil 반환
    var trimmedOrNil: String? {
        let t = trimmed
        return t.isEmpty ? nil : t
    }
}
