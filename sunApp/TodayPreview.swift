//
//  TodayPreview.swift
//  sunApp
//
//  Created by Baurzhan on 9/21/24.
//

import SwiftUI

struct LightExposureChart: View {
    // static example data for one day:
    // each value represents light exposure in minutes for a 2-hour interval
    // maximum exposure per interval is 20 minutes
    let data: [Double] = [5, 10, 20, 18, 3, 17, 9, 3]
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        let maxRadius = (min(geometry.size.width, geometry.size.height) / 2) * 0.8
                        
                        // total angle of the chart is 270 degrees (empty 90 facing bottom)
                        let totalAngle: Double = 270
                        let numberOfSegments = data.count
                        let segmentAngle = totalAngle / Double(numberOfSegments)
                        
                        // center point of the chart
                        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        
                        // current time components:
                        let currentDate = Date()
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.hour, .minute], from: currentDate)
                        let currentHour = components.hour ?? 0
                        let currentMinute = components.minute ?? 0
                        
                        // minutes since 7 AM
                        let minutesSince7AM = (currentHour * 60 + currentMinute) - (7 * 60)
                        
                        // compute currentIndex:
                        let intervalMinutes = 120 // 2 hours * 60 minutes
                        let totalIntervals = data.count
                        let calculatedIndex = Int(ceil(Double(minutesSince7AM) / Double(intervalMinutes)))
                        let currentIndex = max(0, min(totalIntervals, calculatedIndex))
                        
                        ForEach(0..<data.count, id: \.self) { index in
                            let startAngle = Angle(degrees: -225 + segmentAngle * Double(index))
                            let endAngle = Angle(degrees: -225 + segmentAngle * Double(index + 1))
                            
                            // calculating the radius proportionally to the light exposure
                            let radius = maxRadius * CGFloat(data[index] / 20.0)
                            
                            // segment should be filled up to current time
                            let isFilled = index < currentIndex
                            
                            // drawing the segment:
                            if isFilled {
                                LightExposureSegment(startAngle: startAngle, endAngle: endAngle, radius: radius)
                                    .fill(renderColor(index))
                                    .overlay(
                                        // outline
                                        LightExposureSegment(startAngle: startAngle, endAngle: endAngle, radius: maxRadius)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                            } else {
                                LightExposureSegment(startAngle: startAngle, endAngle: endAngle, radius: maxRadius)
                                    .stroke(Color.black, lineWidth: 1)
                                
                            }
                            
                            // position for the hour label:
                            let labelAngle = -225 + segmentAngle * (Double(index) + 0.5)
                            let labelRadius = maxRadius + 20 // positioning slightly outside the chart
                            
                            let x = center.x + labelRadius * cos(CGFloat(labelAngle * .pi / 180))
                            let y = center.y + labelRadius * sin(CGFloat(labelAngle * .pi / 180))
                            
                            // draw the hour label
                            Text(hourLabel(for: index))
                                .font(.subheadline)
                                .position(x: x, y: y)
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            
            List {
                HStack {
                    Text("Total minutes")
                        .padding()
                    Spacer()
                    Text("85/100")
                        .padding()
                }
            
                HStack {
                    Text("Windows achieved")
                        .padding()
                    Spacer()
                    Text("3/8")
                        .padding()
                }

            }
            .background(Color.clear)
            .offset(y: 240)
        }
    }
    
    func hourLabel(for index: Int) -> String {
        let startHour = 7 + index * 2
        return formatHour(startHour)
    }
    
    func formatHour(_ hour: Int) -> String {
        let adjustedHour = hour % 24
        let period = adjustedHour >= 12 ? "PM" : "AM"
        let hourIn12 = adjustedHour % 12 == 0 ? 12 : adjustedHour % 12
        return "\(hourIn12) \(period)"
    }
    
    func renderColor(_ index: Int) -> Color {
        switch data[index] {
        case 0...5:
            return Color.orange
        case 6...10:
            return Color.orange
        case 10...15:
            return Color.blue
        default:
            return Color.blue
        }
    }

}

struct LightExposureSegment: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)

        path.move(to: center)
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        path.closeSubpath()

        return path
    }
}

struct TodayPreview: View {
    @State private var isButtonPressed = false
    
    var body: some View {
        ZStack {
            VStack {
                if isButtonPressed {
                    LiveLightView()
                } else {
                    LightExposureChart()
                        .frame(width: 300, height: 300)
                        .padding()
                }
            }
            
            VStack {
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("Live")
                        .frame(width: 100, height: 100)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundStyle(.white)
                        .font(.title3.bold())
                    
                    
                })
                .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
                    withAnimation {
                        isButtonPressed = pressing
                    }
                }) {}
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isButtonPressed)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    TodayPreview()
}
