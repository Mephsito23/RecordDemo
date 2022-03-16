//
//  Record.swift
//  RecordDemo
//
//  Created by Mephisto on 2022/3/15.
//  打卡记录模型

import Foundation
import SwiftDate

struct Record: Identifiable, Equatable {
    var id: Int
    var content: String
    var creatDate: Date

    var showDate: String {
        creatDate.toFormat("yyyy-MM-dd")
    }

    init(id: Int, content: String, dateStr: String) {
        self.id = id
        self.content = content
        self.creatDate = Date(dateStr) ?? Date().dateAtEndOf(.quarter)
    }
}
