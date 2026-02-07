import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct FocusDistractionJourney: View {
    @Binding var hubState: HubState
    let onComplete: () -> Void
    
    @State private var phase: JourneyPhase = .orientation
    @State private var relevantOpacity: Double = 1.0
    @State private var distractors: [Distractor] = []
    
    struct Distractor: Identifiable {
        let id = UUID()
        let position: CGPoint
        let size: CGFloat
        let color: Color
    }
    
    enum JourneyPhase {
        case orientation
        case environmentalShift
        case immersiveInteraction
        case integration
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            // Relevant content
            VStack(spacing: 25) {
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
            .opacity(relevantOpacity)
            
            // Distracting elements
            ForEach(distractors) { distractor in
                distractorView(distractor)
            }
        }
        .onAppear(perform: startJourney)
    }
    
    private func distractorView(_ distractor: Distractor) -> some View {
        Circle()
            .fill(distractor.color)
            .frame(width: distractor.size, height: distractor.size)
            .position(distractor.position)
            .scaleEffect(phase == .immersiveInteraction ? 1.2 : 1.0)
    }
    
    private var orientationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Attention Focus")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Identify what deserves your attention")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
        }
    }
    
    private var environmentalShiftView: some View {
        VStack(spacing: 25) {
            Text("Important Information")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Focus on the central message while surroundings change")
                .font(.title2)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("Design interfaces guide attention through visual hierarchy")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var immersiveInteractionView: some View {
        VStack(spacing: 20) {
            Text("What captures your attention now?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Relevant content fades as distractions increase")
                .font(.title2)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var integrationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "eye.trianglebadge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Reflection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("How did competing elements affect your focus?")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
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
                relevantOpacity = 0.4
            }
            
            // Start adding distractors
            Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { timer in
                guard phase == .environmentalShift || phase == .immersiveInteraction else {
                    timer.invalidate()
                    return
                }
                
                if distractors.count < 12 {
                    DispatchQueue.main.async {
                        distractors.append(Distractor(
                            position: CGPoint(
                                x: CGFloat.random(in: 40...320),
                                y: CGFloat.random(in: 150...550)
                            ),
                            size: CGFloat.random(in: 25...55),
                            color: [Color.red, Color.blue, Color.orange, Color.purple].randomElement()!
                        ))
                    }
                }
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
                        distractors.removeAll()
                        relevantOpacity = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                        onComplete()
                    }
                }
            }
        }
    }
}