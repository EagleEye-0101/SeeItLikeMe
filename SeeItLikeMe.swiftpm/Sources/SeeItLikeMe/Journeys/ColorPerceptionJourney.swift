import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct ColorPerceptionJourney: View {
    @Binding var hubState: HubState
    let onComplete: () -> Void
    
    @State private var phase: JourneyPhase = .orientation
    @State private var colorShift: Double = 0.0
    @State private var saturation: Double = 1.0
    
    enum JourneyPhase {
        case orientation
        case environmentalShift
        case immersiveInteraction
        case integration
    }
    
    var body: some View {
        ZStack {
            backgroundColor
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
    
    private var backgroundColor: Color {
        Color(
            hue: 0.6 + colorShift * 0.2,
            saturation: saturation,
            brightness: 0.9
        )
    }
    
    private var orientationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "paintpalette")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Color Relationships")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Observe how colors interact and convey meaning")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
        }
    }
    
    private var environmentalShiftView: some View {
        VStack(spacing: 30) {
            colorGrid
            Text("Distinguish between similar hues")
                .font(.title3)
                .foregroundColor(.primary)
        }
    }
    
    private var immersiveInteractionView: some View {
        VStack(spacing: 25) {
            convergingColors
            Text("Which elements stand out? Which blend together?")
                .font(.title3)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var integrationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "paintbrush")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Reflection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("How did color relationships affect your perception?")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    private var colorGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
            ForEach(0..<9, id: \.self) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorForIndex(index))
                    .frame(height: 80)
            }
        }
    }
    
    private var convergingColors: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
            ForEach(0..<16, id: \.self) { index in
                RoundedRectangle(cornerRadius: 10)
                    .fill(convergingColorForIndex(index))
                    .frame(height: 60)
            }
        }
    }
    
    private func colorForIndex(_ index: Int) -> Color {
        let baseHue = Double(index) / 9.0
        return Color(hue: baseHue, saturation: saturation, brightness: 0.8)
    }
    
    private func convergingColorForIndex(_ index: Int) -> Color {
        let baseHue = 0.3 + Double(index) / 16.0 * 0.4 + colorShift * 0.3
        return Color(hue: baseHue, saturation: saturation * (0.7 + colorShift * 0.3), brightness: 0.8)
    }
    
    private func startJourney() {
        // Phase 1: Orientation (5 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                phase = .environmentalShift
            }
            
            // Phase 2: Environmental shift (20 seconds)
            withAnimation(.easeInOut(duration: 20)) {
                colorShift = 1.0
                saturation = 0.6
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
}