//
//  ShadowModifier.swift
//  RecordDemo
//
//  Created by Mephisto on 2022/3/15.
//  阴影

import SwiftUI

struct ShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(3)
            .shadow(color: Color("shadow"), radius: 4, x: 2, y: 4)
    }
}
