//
//  SettingsView.swift
//  sunApp
//
//  Created by Baurzhan on 9/21/24.
//
//  Static "Settings" page for demo

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack {
                Image("ava")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                
                Text("michael raspuzzi")
                    .font(.title3.bold())
                    .foregroundStyle(.gray)
                    .padding()
                
                sampleRows
                
            }
            .padding(.top)
        }
        .preferredColorScheme(.dark)
    }
    
    private var sampleRows: some View {
        VStack {
            ForEach (1...10, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color(.systemGray6))
                    .frame(height: 25)
                
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color(.systemGray6))
                    .frame(height: 15)
                    .padding(.trailing, 50)
                
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color(.systemGray6))
                    .frame(height: 15)
                    .padding(.trailing, 150)
            }
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
