//
//  UpdateManager.swift
//  GlowLog
//
//  Created by 장세희 on 8/19/25.
//

import Foundation
import SwiftUI

@MainActor
final class UpdateManager: ObservableObject {
    @Published var availableUpdate: AppStoreInfo?   // nil이 아니면 알럿 노출

    struct AppStoreInfo: Identifiable {
        let id = UUID()
        let version: String
        let releaseNotes: String?
        let trackViewUrl: URL
    }

    /// 한국 스토어 기준. 필요하면 "us", "jp" 등으로 교체/설정값화
    var countryCode = "kr"

    func checkForUpdate() async {
        guard let bundleID = Bundle.main.bundleIdentifier else { return }
        let endpoint = "https://itunes.apple.com/lookup?bundleId=\(bundleID)&country=\(countryCode)"

        guard let url = URL(string: endpoint) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let lookup = try JSONDecoder().decode(LookupResponse.self, from: data)

            guard let item = lookup.results.first,
                  let storeURL = URL(string: item.trackViewUrl) else { return }

            let latest = item.version
            let current = currentAppVersion()

            if isVersion(latest, greaterThan: current) {
                availableUpdate = .init(version: latest,
                                        releaseNotes: item.releaseNotes,
                                        trackViewUrl: storeURL)
            } else {
                availableUpdate = nil
            }
        } catch {
            // 네트워크 실패 등은 무시 (조용히 패스)
            availableUpdate = nil
        }
    }

    /// 현재 앱의 CFBundleShortVersionString
    private func currentAppVersion() -> String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0"
    }

    /// 1.2.10 vs 1.2.3 같은 세부 버전까지 안전 비교
    private func isVersion(_ a: String, greaterThan b: String) -> Bool {
        let aParts = a.split(separator: ".").map { Int($0) ?? 0 }
        let bParts = b.split(separator: ".").map { Int($0) ?? 0 }
        let count = max(aParts.count, bParts.count)
        for i in 0..<count {
            let av = i < aParts.count ? aParts[i] : 0
            let bv = i < bParts.count ? bParts[i] : 0
            if av != bv { return av > bv }
        }
        return false
    }
}

// MARK: - iTunes Lookup models
private struct LookupResponse: Decodable {
    let resultCount: Int
    let results: [AppItem]
}
private struct AppItem: Decodable {
    let version: String
    let releaseNotes: String?
    let trackViewUrl: String
}
