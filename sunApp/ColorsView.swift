//
//  ColorsView.swift
//  sunApp
//
//  Created by Baurzhan on 9/21/24.
//
//  File for testing custom colors

import SwiftUI

extension ShapeStyle where Self == Color {
    static var ourBlue: Color {
        Color(red: 0, green: 0.3, blue: 0.9)
    }
    static var ourLighterBlue: Color {
        Color(red: 0.2, green: 0.7, blue: 1.0)
    }
}

struct ColorView: View {
    var body: some View {
        Circle()
            .frame(width: 300)
            .foregroundStyle(.ourLighterBlue)
        Circle()
            .frame(width: 300)
            .foregroundStyle(.ourBlue)
    }
}

#Preview {
    ColorView()
}
