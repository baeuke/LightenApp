//
//  LiveLightView.swift
//  sunApp
//
//  Created by Baurzhan on 9/21/24.
//

import SwiftUI

import ARKit

// to get ambient light intensity and color temperature:
class MyARSessionManager: NSObject, ObservableObject, ARSessionDelegate {
    @Published var ambientIntensity: CGFloat = 0.0
    @Published var ambientColorTemperature: CGFloat = 0.0
    private var session: ARSession?
    
    override init() { //overriding default init from NSObject
        super.init() // calling init of the superclass (NSObject) to set up any properties and initial states defined in NSObject. =>
        // => to ensure everything is setup correctly before adding custom things / overriding
        session = ARSession()
        session?.delegate = self // setting delegate property to self: indicating that my class will handle AR session events and updates
        startSession() // begin session right after initialization
    }
    
    func startSession() {
        guard let session = session else { return }
        let configuration = ARWorldTrackingConfiguration()
        // Enable light estimation
        configuration.isLightEstimationEnabled = true // allowing the session to get ambient light estimates from the environment
        session.run(configuration)
    }
    
    func pauseSession() {
        session?.pause()
    }
    
    // to conform to ARSessionDelegate protocol:
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let lightEstimate = frame.lightEstimate // retrieving current estimate from the frame obj
        DispatchQueue.main.async { [weak self] in
            self?.ambientIntensity = lightEstimate?.ambientIntensity ?? 0.0
            self?.ambientColorTemperature = lightEstimate?.ambientColorTemperature ?? 0.0
        }
    } // the session func is called automatically during the session's lifecycle (called whenever the AR session generates a new frame of data; typical frequency 60 frames/sec)
    
    deinit {
        pauseSession()
    }
}


struct LiveLightView: View {
    @StateObject private var arSessionManager = MyARSessionManager()
        
    var body: some View {
        ZStack {
            Circle()
                .fill(setColor(for: arSessionManager.ambientColorTemperature))
                .frame(
                    width: setCircleSize(for: arSessionManager.ambientIntensity),
                    height: setCircleSize(for: arSessionManager.ambientIntensity)
                )
                .blur(radius: 30)
                .animation(.easeInOut(duration: 0.1), value: arSessionManager.ambientColorTemperature)
            
            VStack {
                Text("\(Int(arSessionManager.ambientIntensity)) lumens")
                    .font(.title)
                
                // if light intensity is "normal/healthy" (arbitrary num):
                if Int(arSessionManager.ambientIntensity) > 1000 {
                    Text("Goal achieved!")
                        .font(.title)
                }
            }
        }
        .onAppear {
            arSessionManager.startSession()
        }
        .onDisappear {
            arSessionManager.pauseSession()
        }
    }
        
    // mapping the ambient light intensity (ambientIntensity) to the circle size:
    func setCircleSize(for intensity: CGFloat) -> CGFloat {
        // intensity range (considered):
        let minIntensity: CGFloat = 50
        let maxIntensity: CGFloat = 1000
        
        // size range:
        let minSize: CGFloat = 70
        let maxSize: CGFloat = 600
        
        // ensure intensity is always in the considered range:
        let clampedIntensity = min(max(intensity, minIntensity), maxIntensity)
        
        //normalize between 0 and 1:
        let normalizedIntensity = (clampedIntensity - minIntensity) / (maxIntensity - minIntensity)
        
        let scaledToSizeRange = normalizedIntensity * (maxSize - minSize)
        
        // add minSize shift for correspondance [for cases when lower boundary (minSize) is not 0 ]
        let resultingSize = scaledToSizeRange + minSize
        
        return resultingSize
    }
    
    
    // mapping the ambient light color temperature (ambientColorTemperature) to the color of the circle:
    func setColor(for temperature: CGFloat) -> Color {
        switch temperature {
        case ..<3200:
            return Color.red
        case 3200..<4100:
            return Color.orange
        case 4100..<4900:
            return Color.yellow
        case 4900..<4950:
            return Color.ourLighterBlue
        case 4950..<5100:
            return Color.blue
        default:
            return Color.ourBlue
        }
    }
}

#Preview {
    LiveLightView()
}
