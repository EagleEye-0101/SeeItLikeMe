import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct ReadingStabilityJourney: View {
    @Binding var hubState: HubState
    let onComplete: () -> Void
    
    @State private var phase: JourneyPhase = .orientation
    @State private var lineDrift: CGFloat = 0
    @State private var wordSpacing: CGFloat = 1.0
    
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
            Image(systemName: "text.alignleft")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Reading Rhythm")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Find your natural reading pace")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
        }
    }
    
    private var environmentalShiftView: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<15, id: \.self) { index in
                    HStack {
                        Text(readingText[index])
                            .font(.body)
                            .foregroundColor(.primary)
                            .offset(x: sin(Double(index) + lineDrift) * 15)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var immersiveInteractionView: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(0..<25, id: \.self) { index in
                    HStack {
                        Text(denseReadingText[index % denseReadingText.count])
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .tracking(wordSpacing * 20)
                            .offset(x: cos(Double(index) * 0.5 + lineDrift) * 10)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var integrationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "books.vertical")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Reflection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("How did text instability affect your reading flow?")
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
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                guard phase == .environmentalShift || phase == .immersiveInteraction else {
                    timer.invalidate()
                    return
                }
                
                withAnimation(.linear(duration: 0.1)) {
                    lineDrift += 0.2
                }
            }
            
            withAnimation(.easeInOut(duration: 20)) {
                wordSpacing = -0.3
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
    
    private let readingText = [
        "Reading requires stability and rhythm.",
        "Smooth text presentation supports comprehension.",
        "Visual consistency enables natural flow.",
        "Interface design affects cognitive processing.",
        "Typography choices influence reading speed.",
        "Line height and spacing matter significantly.",
        "Text alignment creates reading pathways.",
        "Consistent formatting reduces fatigue.",
        "Predictable layouts enhance retention.",
        "Good typography is invisible but essential.",
        "White space provides breathing room.",
        "Contrast ratios ensure accessibility.",
        "Font selection affects personality.",
        "Size considerations support all users.",
        "Well-designed text invites engagement."
    ]
    
    private let denseReadingText = [
        "Design", "interfaces", "thoughtfully", "consider", "typography",
        "spacing", "contrast", "hierarchy", "readability", "accessibility",
        "comprehension", "engagement", "retention", "experience", "meaning"
    ]
}