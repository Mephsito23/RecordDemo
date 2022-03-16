//
//  ContentView.swift
//  RecordDemo
//
//  Created by Mephisto on 2022/3/15.
//

import ComposableArchitecture
import SwiftUI

let kScreenWidth = UIScreen.main.bounds.size.width

struct ContentView: View {
    let store: Store<ContentState, ContentAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            let state = viewStore.state
            VStack {
                HStack {
                    DatePicker(selection: viewStore.binding(
                        get: \.date,
                        send: ContentAction.selectDate),
                    displayedComponents: .date) {
                        Text("打卡日期")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .padding(.leading, 10)
                    }

                    Image(systemName: "chevron.right")
                        .padding(.trailing, 10)
                }
                .frame(width: kScreenWidth - 20, height: 44)
                .modifier(ShadowModifier())

                HStack {
                    TextField("请输入打卡内容",
                              text: viewStore.binding(
                                  get: \.content,
                                  send: ContentAction.editContent))
                        .padding(.horizontal, 10)

                    Button("确定") {
                        viewStore.send(.addRecord)
                    }
                    .foregroundColor(Color.white)
                    .frame(width: 50, height: 80)
                    .padding(.horizontal, 10)
                    .background(Color.blue)
                }
                .frame(width: kScreenWidth - 20, height: 80)
                .modifier(ShadowModifier())
                .padding(.top, 10)

                statisticView
                    .padding(.top, 10)

                HStack {
                    Text("打卡列表")
                        .fontWeight(.bold)
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.top, 10)

                if let list = state.model?.list {
                    ScrollView {
                        LazyVStack {
                            ForEach(list) { item in
                                ItemView(item) {
                                    viewStore.send(.deleteRecord($0))
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    Spacer().frame(height: 40)
                }
            }
            .padding(.top, 20)
            .onAppear {
                viewStore.send(.updateList)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }

    var statisticView: some View {
        WithViewStore(self.store) { viewStore in
            if let model = viewStore.state.model {
                VStack(spacing: 8) {
                    HStack {
                        Text("总打卡次数：\(model.totalCount)")
                        Spacer()
                        Text("总打卡天数：\(model.totalDays)")
                    }.padding(.horizontal, 20)
                    HStack {
                        Text("连续打卡天数：\(model.continuousDays)")
                        Spacer()
                        Text("历史最高连续打卡：\(model.maxContinuousDays)")
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: .init(
            initialState: ContentState(),
            reducer: contentReducer,
            environment: .init(fetch: .live)))
    }
}
