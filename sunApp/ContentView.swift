//
//  ContentView.swift
//  sunApp
//
//  Created by Baurzhan on 9/21/24.
//

import SwiftUI

// style to override default button styles:
struct NoOpacityChangeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0) // feedback to understand btn was pressed
            .opacity(1.0) // decreases by default
            .animation(.easeInOut, value: configuration.isPressed) // for smoother scale effect
    }
}

struct ContentView: View {
    @State private var selectedTab = 1
    @State private var isButtonPressed = false

    var body: some View {
        ZStack {
            TabView (selection: $selectedTab) {
                ProgressView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Progress")
                    }
                    .tag(0)
                
                VStack {
                    if isButtonPressed {
                        LiveLightView()
                            .transition(.opacity)
                    } else {
                        LightExposureChart()
                            .frame(width: 300, height: 300)
                            .padding()
                            .transition(.opacity)
                    }
                }
                    .tabItem {
                        Image(systemName: "sun.max.fill")
                        Text("Today")
                    }
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Settings")
                    }
                    .tag(2)
            }
            .accentColor(.yellow)
            
            if selectedTab == 1 {
                VStack {
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "sun.max.fill")
                            .frame(width: 90, height: 90)
                            .background(Color.yellow)
                            .clipShape(Circle())
                            .foregroundStyle(.white)
                            .font(.title2.bold())
                            
                    })
                    .buttonStyle(NoOpacityChangeButtonStyle())
                    .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
                        withAnimation {
                            isButtonPressed = pressing
                        }
                        
                    }) {}
                    .offset(y: 16) // to cover the middle tab icon
                }
                .transition(.move(edge: .bottom))
            }
        }
        .preferredColorScheme(.dark)
    }
}


#Preview {
    ContentView()
}
