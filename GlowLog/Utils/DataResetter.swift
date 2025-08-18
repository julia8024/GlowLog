//
//  DataResetter.swift
//  GlowLog
//
//  Created by 장세희 on 8/19/25.
//

import SwiftData

enum DataResetter {
    
    /// SwiftData의 모든 모델 인스턴스를 삭제하고, 앱 환경설정을 초기화합니다
    static func resetAll(in context: ModelContext) throws {
        // SwiftData 모델 삭제
        try deleteAllModels(in: context)
    }
    
    // MARK: - SwiftData
    
    /// 프로젝트의 모든 @Model 타입을 이곳에 나열하세요
    private static func deleteAllModels(in context: ModelContext) throws {
        try deleteAll(of: Habit.self, in: context)
        
        // 다른 모델이 있다면 여기에 추가
    }
    
    /// 제네릭 삭제: 특정 @Model 타입의 모든 레코드를 삭제
    private static func deleteAll<T: PersistentModel>(of type: T.Type, in context: ModelContext) throws {
        let fetch = FetchDescriptor<T>() // 전부
        let items = try context.fetch(fetch)
        for obj in items {
            context.delete(obj)
        }
        if context.hasChanges {
            try context.save()
        }
    }
}
