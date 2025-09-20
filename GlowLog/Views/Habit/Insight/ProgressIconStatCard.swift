//
//  ProgressIconStatCard.swift
//  GlowLog
//
//  Created by 장세희 on 8/17/25.
//

import SwiftUI

struct ProgressStage {
    let icon: String
    let message: String
    let cheer: String
}

extension ProgressStage {
    static func stage(for progress: Double) -> ProgressStage {
        switch progress {
        case 0.0..<0.25:
            return ProgressStage(
                icon: "moon.fill",
                message: "이제 시작이에요",
                cheer: "아직은 어둡지만, 작은 불빛이 길을 밝히고 있어요"
            )
        case 0.25..<0.5:
            return ProgressStage(
                icon: "cloud.moon.fill",
                message: "열심히 노력 중",
                cheer: "구름 사이로 달빛이 비치듯, 조금씩 나아가고 있어요"
            )
        case 0.5..<0.75:
            return ProgressStage(
                icon: "cloud.fill",
                message: "절반 이상 달성",
                cheer: "구름이 모여도 당신의 꾸준함은 흐려지지 않아요"
            )
        case 0.75..<1.0:
            return ProgressStage(
                icon: "cloud.sun.fill",
                message: "거의 다 왔어요",
                cheer: "구름 사이로 해가 나오듯, 성과가 드러나고 있어요"
            )
        default:
            return ProgressStage(
                icon: "sun.max.fill",
                message: "완벽 달성!",
                cheer: "드디어 해가 떴어요! 당신의 노력이 빛나고 있어요"
            )
        }
    }
}

struct ProgressIconStatCard: View {
    let title: String
    let progress: Double
    let hasBorder: Bool?
    
    init(title: String, progress: Double, hasBorder: Bool? = true) {
        self.title = title
        self.progress = progress
        self.hasBorder = hasBorder
    }
    
    private var stage: ProgressStage {
        .stage(for: progress)
    }
    
    var body: some View {
        BaseStatCard(title: title, hasBorder: hasBorder ?? true) {
            VStack(spacing: 15) {
                Image(systemName: stage.icon)
                    .font(.system(size: 28))
                    .foregroundColor(Color("black"))
                
                VStack (spacing: 10) {
                    Text(stage.message)
                        .textStyle(.subtitle)
                        .multilineTextAlignment(.center)
                    
                    Text(stage.cheer)
                        .textStyle(.smaller, color: .secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}
