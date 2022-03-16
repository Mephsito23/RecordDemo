//
//  Continuous.swift
//  RecordDemo
//
//  Created by Mephisto on 2022/3/15.
//

import Foundation

// 连续打卡记录模型
struct Continuous {
    var diffDay: Int
    var flag: Int
}

// 数据查询模型
struct QueryModel: Identifiable, Equatable {
    var id: String {
        UUID().uuidString
    }

    var totalCount: Int
    var totalDays: Int
    var continuousDays: Int
    var maxContinuousDays: Int
    var list: [Record]
}
