import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct VisualStrainJourney: View {
    @Binding var hubState: HubState
    let onComplete: () -> Void
    
    @State private var phase: JourneyPhase = .orientation
    @State private var brightness: Double = 1.0
    @State private var contrast: Double = 1.0
    @State private var textDensity: CGFloat = 1.0
    
    enum JourneyPhase {
        case orientation
        case environmentalShift
        case immersiveInteraction
        case integration
    }
    
    var body: some View {
        ZStack {
            Color.black
                .brightness(brightness)
                .contrast(contrast)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                switch phase {
                case .orientation:
                    orientationView
                case .environmentalShift:
                    environmentalShiftView
                case .immersiveInteraction:
                    immersiveInteractionView
                case .integration:
                    integrationView
                }
            }
            .padding()
        }
        .onAppear(perform: startJourney)
    }
    
    private var orientationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "eye")
                .font(.system(size: 60))
                .foregroundColor(.white)
            
            Text("Visual Comfort")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Notice how text appears on screen")
                .font(.title2)
                .foregroundColor(.white.opacity(0.8))
        }
    }
    
    private var environmentalShiftView: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(0..<20, id: \.self) { index in
                    Text(loremIpsum)
                        .font(.body)
                        .foregroundColor(.white)
                        .lineSpacing(8 * textDensity)
                        .padding(.vertical, 2)
                }
            }
        }
    }
    
    private var immersiveInteractionView: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<30, id: \.self) { index in
                    Text(denseText)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .lineSpacing(4)
                }
            }
        }
    }
    
    private var integrationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "eye.slash")
                .font(.system(size: 60))
                .foregroundColor(.white)
            
            Text("Reflection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("How did visual density affect your reading experience?")
                .font(.title2)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    private func startJourney() {
        // Phase 1: Orientation (5 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                phase = .environmentalShift
            }
            
            // Phase 2: Environmental shift (20 seconds)
            withAnimation(.easeInOut(duration: 20)) {
                brightness = -0.3
                contrast = 0.7
                textDensity = 0.6
            }
            
            // Phase 3: Immersive interaction (20 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    phase = .immersiveInteraction
                }
                
                // Phase 4: Integration (12 seconds)
                DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        phase = .integration
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                        onComplete()
                    }
                }
            }
        }
    }
    
    private let loremIpsum = "Design interfaces thoughtfully. Every choice affects perception. Typography, spacing, and contrast create meaning. User experience emerges from these subtle foundations. Consider how small adjustments influence understanding."
    
    private let denseText = "Interface design requires careful consideration of visual hierarchy and readability. Small changes in spacing, font weight, and contrast can dramatically affect user comprehension and comfort. Thoughtful design creates inclusive experiences that serve diverse needs."
}