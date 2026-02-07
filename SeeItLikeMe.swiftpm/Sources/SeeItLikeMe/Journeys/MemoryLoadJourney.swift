import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct MemoryLoadJourney: View {
    @Binding var hubState: HubState
    let onComplete: () -> Void
    
    @State private var phase: JourneyPhase = .orientation
    @State private var patternVisible: Bool = false
    @State private var patternOpacity: Double = 1.0
    @State private var distractionOpacity: Double = 0.0
    @State private var pattern: [Bool] = Array(repeating: false, count: 16)
    
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
            Image(systemName: "brain")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Pattern Recognition")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Observe and remember the pattern that appears")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
        }
    }
    
    private var environmentalShiftView: some View {
        VStack(spacing: 30) {
            Text("Memorize this pattern")
                .font(.title)
                .foregroundColor(.primary)
            
            patternGrid
                .opacity(patternOpacity)
        }
    }
    
    private var immersiveInteractionView: some View {
        VStack(spacing: 25) {
            Text("Recall the pattern while distractions appear")
                .font(.title2)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            ZStack {
                patternGrid
                    .opacity(0.3)
                
                distractionOverlay
                    .opacity(distractionOpacity)
            }
        }
    }
    
    private var integrationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "lightbulb")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Reflection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("How did competing information affect your recall?")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    private var patternGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
            ForEach(0..<16, id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(pattern[index] ? Color.accentColor : Color.secondary.opacity(0.3))
                    .frame(height: 50)
            }
        }
    }
    
    private var distractionOverlay: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
            ForEach(0..<16, id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.red.opacity(0.1))
                    .frame(height: 50)
                    .overlay(
                        Text("?")
                            .font(.title2)
                            .foregroundColor(.red)
                    )
            }
        }
    }
    
    private func startJourney() {
        // Generate random pattern
        pattern = (0..<16).map { _ in Bool.random() }
        
        // Phase 1: Orientation (5 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                phase = .environmentalShift
                patternVisible = true
            }
            
            // Show pattern briefly
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut(duration: 1.5)) {
                    patternOpacity = 0.0
                }
            }
            
            // Phase 2: Environmental shift (18 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    phase = .immersiveInteraction
                }
                
                // Introduce distractions
                withAnimation(.easeIn(duration: 2.0)) {
                    distractionOpacity = 1.0
                }
            }
            
            // Phase 3: Immersive interaction (18 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    distractionOpacity = 0.0
                }
                
                // Phase 4: Integration (12 seconds)
                DispatchQueue.main.asyncAfter(deadline: .now() + 18) {
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