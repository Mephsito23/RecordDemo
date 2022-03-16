//
//  ContentStore.swift
//  RecordDemo
//
//  Created by Mephisto on 2022/3/16.
//

import Combine
import ComposableArchitecture
import Foundation

struct ContentState: Equatable {
    var date = Date()
    var content = ""
    var model: QueryModel?
}

enum ContentAction: Equatable {
    case selectDate(Date)
    case editContent(String)
    case updateList
    case addRecord
    case deleteRecord(Record)
}

struct ContentEnvironment {
    let fetch: ContentClient
    let mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

let contentReducer = Reducer<ContentState, ContentAction, ContentEnvironment> {
    state, action, _ in
    switch action {
    case let .selectDate(date):
        print("date===>\(date)")
        state.date = date
        state.model = RecordManager.share.queryRecordList(date: date)
        return .none
    case let .editContent(content):
        state.content = content
        return .none
    case .updateList:
        state.model = RecordManager.share.queryRecordList(date: state.date)
        return .none
    case .addRecord:
        state.model = RecordManager.share.insertRecord(content: state.content, date: state.date)
        return .none
    case let .deleteRecord(item):
        state.model = RecordManager.share.deleteRecord(id: item.id, date: state.date)
        return .none
    default:
        return .none
    }
}

// MARK: - ContentClient

struct ContentClient {}

extension ContentClient {
    static let live = Self(
    )
}
