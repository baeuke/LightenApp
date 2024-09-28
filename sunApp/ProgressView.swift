//
//  ProgressView.swift
//  sunApp
//
//  Created by Baurzhan on 9/21/24.
//
//  Static "Progress" page for demo

import SwiftUI
import Charts

struct LightData: Identifiable {
    let id = UUID()
    let day: String
    let amount: Double
}

struct ProgressView: View {
    let lightDataMinutes: [LightData] = [
        LightData(day: "Mon", amount: 33),
        LightData(day: "Tue", amount: 45),
        LightData(day: "Wed", amount: 40),
        LightData(day: "Thu", amount: 40),
        LightData(day: "Fri", amount: 37),
        LightData(day: "Sat", amount: 90),
        LightData(day: "Sun", amount: 88)
    ]
    
    let lightDataWindows: [LightData] = [
        LightData(day: "Mon", amount: 2),
        LightData(day: "Tue", amount: 4),
        LightData(day: "Wed", amount: 3),
        LightData(day: "Thu", amount: 3),
        LightData(day: "Fri", amount: 2),
        LightData(day: "Sat", amount: 9),
        LightData(day: "Sun", amount: 8)
    ]
    
    let icons = [
        "sun.max.fill",
        "lightbulb.fill",
        "bolt.fill"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    Text("Minutes")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .bold()
                    
                    Chart {
                        ForEach(lightDataMinutes) { data in
                            BarMark(
                                x: .value("Day", data.day),
                                y: .value("Minutes", data.amount)
                            )
                            .foregroundStyle(Color.yellow)
                        }
                    }
                    .frame(height: 200)
                    .padding()
                    
                    Text("Windows")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .bold()
                    
                    Chart {
                        ForEach(lightDataWindows) { data in
                            BarMark(
                                x: .value("Day", data.day),
                                y: .value("Windows", data.amount)
                            )
                            .foregroundStyle(Color.blue)
                        }
                    }
                    .frame(height: 200)
                    .padding()
                    
                    HStack {
                        ForEach(0..<icons.count, id: \.self) { index in
                            
                            if index == 1 { Spacer() } // distribute items
                            
                            Image(systemName: icons[index])
                            // List in dark mode -mimicking styles:
                                .font(.title2)
                                .foregroundColor(.yellow)
                                .frame(width: 100, height: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            
                            if index == 1 { Spacer() }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.top, .horizontal])
                }
            }
            .navigationTitle("Progress")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ProgressView()
}
