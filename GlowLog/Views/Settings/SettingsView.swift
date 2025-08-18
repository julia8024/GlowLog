//
//  SettingsView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.requestReview) private var requestReview
    @Environment(\.openURL) private var openURL

    @State private var showingResetAlert: Bool = false
    @State private var showingResetDone: Bool = false
    @State private var showingResetFail: Bool = false

    var body: some View {
        VStack (alignment: .leading, spacing: 30) {
            Text("설정")
                .textStyle(.headline)
            
            VStack(alignment: .leading, spacing: 15) {
                VersionRow()
                
                Divider()
                
                Button {
                    requestReview() // 시스템 리뷰 팝업 (조건 충족 시)
                } label: {
                    Label("앱 평가하기", systemImage: "star")
                        .textStyle(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                Button {
                    // 문의: 노션 폼 링크로 연결
                    openURL(URL(string: "https://julia8024.notion.site/253f5a761a4c80e4b447c05a1a1e6d3d")!)
                } label: {
                    Label("문의 및 의견 보내기", systemImage: "envelope")
                        .textStyle(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(15)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
                

            VStack(alignment: .leading, spacing: 6) {
                Button(role: .destructive) {
                    showingResetAlert = true
                } label: {
                    Label("모든 데이터 초기화", systemImage: "trash")
                        .textStyle(.body, color: .red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                Text("모든 습관과 기록이 삭제됩니다. 이 작업은 취소할 수 없습니다.")
                    .textStyle(.smaller, color: .gray)
            }
            .alert("모든 데이터를 초기화할까요?", isPresented: $showingResetAlert) {
                Button("취소", role: .cancel) {}
                Button("초기화", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("이 작업은 되돌릴 수 없습니다.")
            }
            .alert(isPresented: $showingResetFail) {
                Alert(title: Text("모든 앱 데이터를 초기화했습니다"), dismissButton: .default(Text("확인")))
            }
            .alert(isPresented: $showingResetFail) {
                Alert(title: Text("데이터 초기화에 실패했습니다"), message: Text("해당 문제가 지속적으로 발생한다면 문의 바랍니다"), dismissButton: .default(Text("확인")))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }

    private func resetAllData() {
        // SwiftData 전체 삭제 로직 연결 (주의!)
        do {
            try DataResetter.resetAll(in: context)
            showingResetDone = true
        } catch {
            // 실패 처리: 에러 Alert
            showingResetFail = true
        }
    }
}

/// 앱 버전/빌드 표시
struct VersionRow: View {
    private var version: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        return "\(v) (\(b))"
    }
    var body: some View {
        HStack {
            Label("앱 버전", systemImage: "info.circle")
                .textStyle(.body)
            Spacer()
            Text(version)
                .textStyle(.body, color: .gray)
        }
    }
}
