import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct InteractionPrecisionJourney: View {
    @Binding var hubState: HubState
    let onComplete: () -> Void
    
    @State private var phase: JourneyPhase = .orientation
    @State private var targetSize: CGFloat = 60
    @State private var responseDelay: Double = 0.0
    @State private var tapCount: Int = 0
    @State private var missedTaps: Int = 0
    
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
            Image(systemName: "cursorarrow.click")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Interaction Accuracy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Precise interactions require optimal target sizing")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
        }
    }
    
    private var environmentalShiftView: some View {
        VStack(spacing: 30) {
            Text("Tap the targets as they appear")
                .font(.title)
                .foregroundColor(.primary)
            
            targetArea
                .frame(height: 300)
            
            Text("Targets: \(tapCount) | Missed: \(missedTaps)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var immersiveInteractionView: some View {
        VStack(spacing: 25) {
            Text("Smaller targets, delayed response")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            challengingTargetArea
                .frame(height: 300)
            
            Text("Precision becomes more challenging")
                .font(.title2)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var integrationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cursorarrow")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Reflection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("How did target size and timing affect your interactions?")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    private var targetArea: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<5) { index in
                    Button(action: {
                        handleTap()
                    }) {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: targetSize, height: targetSize)
                    }
                    .buttonStyle(.plain)
                    .position(
                        x: CGFloat.random(in: targetSize...geometry.size.width - targetSize),
                        y: CGFloat.random(in: targetSize...geometry.size.height - targetSize)
                    )
                }
            }
        }
    }
    
    private var challengingTargetArea: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<8) { index in
                    Button(action: {
                        handleDelayedTap()
                    }) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: targetSize * 0.6, height: targetSize * 0.6)
                    }
                    .buttonStyle(.plain)
                    .position(
                        x: CGFloat.random(in: targetSize...geometry.size.width - targetSize),
                        y: CGFloat.random(in: targetSize...geometry.size.height - targetSize)
                    )
                }
            }
        }
    }
    
    private func handleTap() {
        withAnimation(.easeInOut(duration: 0.2)) {
            tapCount += 1
        }
    }
    
    private func handleDelayedTap() {
        DispatchQueue.main.asyncAfter(deadline: .now() + responseDelay) {
            withAnimation(.easeInOut(duration: 0.2)) {
                tapCount += 1
            }
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
                targetSize = 40
            }
            
            // Phase 3: Immersive interaction (20 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    phase = .immersiveInteraction
                }
                
                withAnimation(.easeInOut(duration: 15)) {
                    targetSize = 25
                    responseDelay = 0.3
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
}