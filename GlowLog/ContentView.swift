//
//  ContentView.swift
//  GlowLog
//
//  Created by 장세희 on 8/16/25.
//
import SwiftUI

struct ContentView: View {
    @State var isLaunching: Bool = true
    @StateObject private var updater = UpdateManager()
    @Environment(\.openURL) private var openURL

    var body: some View {
        Group {
            if isLaunching {
                SplashView()
                    .task {
                        await updater.checkForUpdate()
                        // 스플래시 딜레이
                        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1s
                        isLaunching = false
                    }
            } else {
                BottomTabView()
            }
        }
        .alert("업데이트가 있어요", isPresented: isUpdateAlertPresented) {
            Button("나중에", role: .cancel) {
                updater.availableUpdate = nil
            }
            Button("업데이트") {
                if let url = updater.availableUpdate?.trackViewUrl {
                    openURL(url)
                }
                updater.availableUpdate = nil
            }
        } message: {
            if let info = updater.availableUpdate {
                Text("새 버전 \(info.version)이 출시되었어요\n\(info.releaseNotes ?? "개선 및 버그 수정이 포함되어 있습니다")")
            } else {
                Text("")
            }
        }
    }

    private var isUpdateAlertPresented: Binding<Bool> {
        Binding(
            get: { updater.availableUpdate != nil && !isLaunching },
            set: { newVal in if !newVal { updater.availableUpdate = nil } }
        )
    }
}
