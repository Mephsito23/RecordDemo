//
//  ItemView.swift
//  RecordDemo
//
//  Created by Mephisto on 2022/3/15.
//  打卡记录视图

import SwiftUI

struct ItemView: View {
    let record: Record
    let delete: (Record)->Void

    init(_ record: Record, delete: @escaping (Record)->Void) {
        self.record = record
        self.delete = delete
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(record.showDate)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text(record.content)
                    .padding(.bottom, 10)
            }
            .padding(.leading, 10)
            Spacer()

            Button {
                delete(record)
            } label: {
                Image(systemName: "trash.circle.fill")
                    .foregroundColor(Color.red)
                    .font(.system(size: 30))
                    .padding(.trailing, 10)
            }
        }
        .frame(width: kScreenWidth - 20)
        .modifier(ShadowModifier())
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(Record(id: 1, content: "111", dateStr: "2022-03-15 22:10:20"), delete: { _ in

        })
    }
}
