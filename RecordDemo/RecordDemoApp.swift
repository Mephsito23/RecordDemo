//
//  RecordDemoApp.swift
//  RecordDemo
//
//  Created by Mephisto on 2022/3/15.
//

import ComposableArchitecture
import SwiftDate
import SwiftUI

@main
struct RecordDemoApp: App {
    let store: Store<ContentState, ContentAction> =
        .init(initialState: ContentState(),
              reducer: contentReducer,
              environment: .init(fetch: .live))
    init() {
        // 设置时区
        let chinese = Region(calendar: Calendars.gregorian, zone: Zones.asiaShanghai, locale: Locales.chinese)
        SwiftDate.defaultRegion = chinese
    }

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
