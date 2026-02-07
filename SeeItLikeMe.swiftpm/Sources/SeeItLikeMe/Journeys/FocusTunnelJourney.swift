import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct FocusTunnelJourney: View {
    @Binding var hubState: HubState
    let onComplete: () -> Void
    
    @State private var phase: JourneyPhase = .orientation
    @State private var tunnelRadius: CGFloat = 300
    @State private var importantEvents: [ImportantEvent] = []
    
    struct ImportantEvent: Identifiable {
        let id = UUID()
        let position: CGPoint
        let isVisible: Bool
    }
    
    enum JourneyPhase {
        case orientation
        case environmentalShift
        case immersiveInteraction
        case integration
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            // Peripheral masking
            GeometryReader { geometry in
                ZStack {
                    // Outer darkened area
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.black.opacity(0.8)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: tunnelRadius
                    )
                    .mask(
                        Rectangle()
                            .foregroundColor(.white)
                    )
                    
                    // Content
                    contentInView
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear(perform: startJourney)
    }
    
    private var contentInView: some View {
        ZStack {
            // Central focal point
            VStack(spacing: 20) {
                Image(systemName: "target")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                Text("Central Focus")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // Important peripheral elements
            ForEach(importantEvents) { event in
                if event.isVisible {
                    Text("Important Information")
                        .font(.caption)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.7))
                                .padding(.horizontal, 8)
                        )
                        .position(event.position)
                }
            }
        }
    }
    
    private var orientationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "circle.hexagongrid")
                .font(.system(size: 60))
                .foregroundColor(.white)
            
            Text("Peripheral Awareness")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Notice what lies beyond your direct focus")
                .font(.title2)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var environmentalShiftView: some View {
        VStack(spacing: 30) {
            Text("Focus narrows over time")
                .font(.title)
                .foregroundColor(.white)
            
            // Visual representation of shrinking focus
            Circle()
                .strokeBorder(Color.white, lineWidth: 2)
                .frame(width: tunnelRadius * 2, height: tunnelRadius * 2)
        }
    }
    
    private var immersiveInteractionView: some View {
        VStack(spacing: 25) {
            Text("Peripheral information becomes less accessible")
                .font(.title2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("What are you missing?")
                .font(.title3)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    private var integrationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "eye.circle")
                .font(.system(size: 60))
                .foregroundColor(.white)
            
            Text("Reflection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("How did restricted focus affect your awareness?")
                .font(.title2)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    private func startJourney() {
        // Initialize important events
        importantEvents = [
            ImportantEvent(position: CGPoint(x: 100, y: 150), isVisible: false),
            ImportantEvent(position: CGPoint(x: 300, y: 100), isVisible: false),
            ImportantEvent(position: CGPoint(x: 80, y: 300), isVisible: false),
            ImportantEvent(position: CGPoint(x: 280, y: 350), isVisible: false)
        ]
        
        // Phase 1: Orientation (5 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                phase = .environmentalShift
            }
            
            // Phase 2: Environmental shift (18 seconds)
            withAnimation(.easeInOut(duration: 18)) {
                tunnelRadius = 120
                
                // Make some events visible periodically
                for (index, event) in importantEvents.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index * 3)) {
                        importantEvents[index].isVisible = true
                    }
                }
            }
            
            // Phase 3: Immersive interaction (18 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 23) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    phase = .immersiveInteraction
                }
                
                // Phase 4: Integration (12 seconds)
                DispatchQueue.main.asyncAfter(deadline: .now() + 18) {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        phase = .integration
                        tunnelRadius = 300
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                        onComplete()
                    }
                }
            }
        }
    }
}