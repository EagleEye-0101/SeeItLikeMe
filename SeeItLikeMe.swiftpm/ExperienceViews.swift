//
//  ExperienceViews.swift
//  SeeItLikeMe
//
//  Created by student on 10/02/26.
//



//
//  JourneyPhase.swift
//  SeeItLikeMe
//
//  Created by Teacher on 10/02/2026.
//


import SwiftUI

enum JourneyPhase {
    case orientation
    case shift
    case immersive
    case integration
}

struct ExperienceJourneyWrapper: View {
    let kind: ExperienceKind
    @EnvironmentObject var store: AppStore
    @State private var phase: JourneyPhase = .orientation
    @State private var progress: Double = 0.0 // 0 to 1
    
    var body: some View {
        ZStack {
            // The Experience Content
            ExperienceContent(kind: kind, phase: phase, progress: progress)
                .blur(radius: phase == .orientation ? 10 : 0)
                .opacity(phase == .orientation ? 0.3 : 1.0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            // Phase Overlays
            if phase == .orientation {
                VStack(spacing: 20) {
                    Text(kind.rawValue)
                        .font(.title.weight(.light))
                    Text(orientationText(for: kind))
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .opacity(0.7)
                }
                .transition(.opacity.combined(with: .scale))
            }
            
            if phase == .integration {
                VStack {
                    Spacer()
                    Text(reflectionText(for: kind))
                        .font(.body.italic())
                        .multilineTextAlignment(.center)
                        .padding(40)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .padding(.bottom, 120)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Back Button - Fixed Top-Left Safe Area
            VStack {
                HStack {
                    BackButton {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            store.flow = .hub
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            startJourney()
        }
    }
    
    private func startJourney() {
        // Phase 1: Orientation (5s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeInOut(duration: 2.0)) {
                phase = .shift
            }
            // Phase 2: Shift (Variable duration)
            let driftTime = kind.driftDuration
            withAnimation(.linear(duration: driftTime)) {
                progress = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + driftTime) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    phase = .immersive
                    store.hubState = .immersed(kind)
                }
                
                // Phase 3: Immersive (15s)
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    withAnimation(.easeInOut(duration: 2.0)) {
                        phase = .integration
                        store.hubState = .integrating(kind)
                    }
                }
            }
        }
    }
    
    private func orientationText(for kind: ExperienceKind) -> String {
        switch kind {
        case .visualStrain: return "Notice how clarity is often a privilege of high contrast and clean space."
        case .colorPerception: return "Observe how meaning can be lost when color becomes the only messenger."
        case .focusTunnel: return "Feel the narrowing of attention as the periphery fades away."
        case .readingStability: return "Experience the effort of anchoring focus on shifting lines."
        case .memoryLoad: return "Witness the fragility of patterns under the weight of distraction."
        case .focusDistraction: return "Observe the quiet competition between intent and noise."
        case .cognitiveLoad: return "Feel the build of mental density as instructions multiply."
        case .interactionPrecision: return "Notice the subtle drift between intent and interaction."
        }
    }
    
    private func reflectionText(for kind: ExperienceKind) -> String {
        switch kind {
        case .visualStrain: return "When UI density exceeds comfort, focus becomes fatigue."
        case .colorPerception: return "True accessibility relies on more than just hue."
        case .focusTunnel: return "Context is easily lost when the viewport of attention narrows."
        case .readingStability: return "Stability is the foundation of comprehension."
        case .memoryLoad: return "Retention is a finite resource in a cluttered environment."
        case .focusDistraction: return "Motion commands attention; use it with intention."
        case .cognitiveLoad: return "Simplicity is not a lack of complexity, but a mastery of it."
        case .interactionPrecision: return "Precision is a dialogue between the user and the system."
        }
    }
}

struct ExperienceContent: View {
    let kind: ExperienceKind
    let phase: JourneyPhase
    let progress: Double
    
    var body: some View {
        Group {
            switch kind {
            case .visualStrain: VisualStrainExperience(progress: progress)
            case .colorPerception: ColorPerceptionExperience(progress: progress)
            case .focusTunnel: FocusTunnelExperience(progress: progress)
            case .readingStability: ReadingStabilityExperience(progress: progress)
            case .memoryLoad: MemoryLoadExperience(progress: progress)
            case .focusDistraction: FocusDistractionExperience(progress: progress)
            case .cognitiveLoad: CognitiveLoadExperience(progress: progress)
            case .interactionPrecision: InteractionPrecisionExperience(progress: progress)
            }
        }
    }
}

// --- Experience Implementations ---

struct VisualStrainExperience: View {
    let progress: Double
    
    // Core content text
    private let contentText = """
    Reading requires a stable visual environment.
    
    When contrast is reduced, the eyes must work harder to distinguish shapes.
    
    When brightness is uneven, the pupil constantly adjusts, leading to fatigue.
    
    When clarity drifts, the lens muscle strains to find focus.
    
    Subtle changes, over time, create a cumulative burden that is hard to ignore but easy to underestimate.
    """
    
    var body: some View {
        ZStack {
            // Layer 1: Background & Brightness Imbalance
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            // Subtle Radial Gradient that shifts brightness
            // Darkens corners or brightens center unevenly based on progress
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.black.opacity(progress * 0.15) // Corner vignette
                ]),
                center: .center,
                startRadius: 100,
                endRadius: 500
            )
            .ignoresSafeArea()
            .opacity(0.8)
            .blendMode(.multiply)
            
            // Layer 2: Content
            VStack(spacing: 24) {
                ForEach(contentText.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                    Text(paragraph)
                        .font(.system(size: 18, weight: .regular, design: .serif))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(8 - (progress * 2)) // Reduced line spacing = visual density
                        .foregroundColor(
                            // Contrast reduction: Text gets lighter (greyer)
                            Color.primary.opacity(1.0 - (progress * 0.45))
                        )
                        .blur(radius: progress * 0.6) // Micro blur: Subtle but annoying
                }
            }
            .padding(.horizontal, 40)
            .drawingGroup() // Helps with rendering performance of blurs
            
            // Layer 3: Environmental Noise/Grain (Optional, very subtle)
            // Adds a subconscious "texture" to the strain
            Color.white.opacity(0.02)
                .blendMode(.overlay)
        }
    }
}



struct ColorPerceptionExperience: View {
    let progress: Double
    
    // Game State
    @State private var targetIndex: Int = Int.random(in: 0..<9)
    @State private var baseColor: Color = .blue
    @State private var feedbackScale: CGFloat = 1.0
    @State private var tappedIndex: Int? = nil
    
    // Grid Setup
    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    
    var body: some View {
        VStack(spacing: 40) {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<9) { index in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color(for: index))
                        .aspectRatio(1.0, contentMode: .fit)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.5), lineWidth: tappedIndex == index ? 2 : 0)
                        )
                        .scaleEffect(tappedIndex == index ? 0.95 : 1.0)
                        .onTapGesture {
                            handleTap(index)
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: tappedIndex)
                }
            }
            .padding(40)
            .drawingGroup()
            
            // "Integration" phase text
            if progress > 0.9 {
                Text("As sensitivity fades, certainty becomes a guess.")
                    .font(.body.italic())
                    .foregroundColor(.secondary)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.0), value: progress)
            }
        }
        .onAppear {
            generateRound()
        }
    }
    
    // MARK: - Logic
    
    private func color(for index: Int) -> Color {
        if index == targetIndex {
            // Calculate difference based on progress
            // Start (0.0): Easy (Difference ~0.15 hue)
            // End (1.0): Impossible (Difference ~0.005 hue)
            let difficulty = 1.0 - progress
            let hueDiff = 0.005 + (difficulty * 0.15)
            
            // Shift hue slightly
            var hue: CGFloat = 0
            var sat: CGFloat = 0
            var bri: CGFloat = 0
            var alpha: CGFloat = 0
            
            UIColor(baseColor).getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)
            
            // Wrap hue
            let newHue = (hue + CGFloat(hueDiff)).truncatingRemainder(dividingBy: 1.0)
            
            // Desaturate slightly with progress to add difficulty
            let newSat = max(0.2, sat - (CGFloat(progress) * 0.3))
            
            return Color(hue: newHue, saturation: newSat, brightness: bri)
        } else {
            // Base color, but also desaturating over time
            var hue: CGFloat = 0
            var sat: CGFloat = 0
            var bri: CGFloat = 0
            var alpha: CGFloat = 0
             UIColor(baseColor).getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)
             
             let newSat = max(0.2, sat - (CGFloat(progress) * 0.3))
             
             return Color(hue: hue, saturation: newSat, brightness: bri)
        }
    }
    
    private func handleTap(_ index: Int) {
        tappedIndex = index
        
        // Prepare next round with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            tappedIndex = nil
            generateRound()
        }
    }
    
    private func generateRound() {
        // Pick new target
        targetIndex = Int.random(in: 0..<9)
        
        // Pick new base color
        // Avoid too dark or too light
        baseColor = Color(
            hue: Double.random(in: 0...1),
            saturation: Double.random(in: 0.6...0.9),
            brightness: Double.random(in: 0.7...0.9)
        )
    }
}

struct FocusTunnelExperience: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            // Background Content
            VStack(spacing: 20) {
                ForEach(0..<20) { _ in
                    Text("Important contextual information that provides meaning to the current task.")
                        .font(.caption)
                        .opacity(0.3)
                }
            }
            
            // Focus Window Mask
            GeometryReader { geo in
                RadialGradient(
                    gradient: Gradient(colors: [.clear, .black]),
                    center: .center,
                    startRadius: 100 - (progress * 80),
                    endRadius: 400 - (progress * 300)
                )
                .ignoresSafeArea()
            }
        }
    }
}

struct ReadingStabilityExperience: View {
    let progress: Double
    @State private var offset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(0..<8) { i in
                Text("Continuous text requires a stable baseline. When elements shift, the cognitive cost of tracking increases significantly.")
                    .font(.title3)
                    .offset(x: i % 2 == 0 ? (progress * offset) : -(progress * offset))
            }
        }
        .padding(40)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                offset = 15
            }
        }
    }
}

struct MemoryLoadExperience: View {
    let progress: Double
    @State private var pattern: [Int] = (0..<9).map { _ in Int.random(in: 0...1) }
    
    var body: some View {
        VStack(spacing: 20) {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(60)), count: 3)) {
                ForEach(0..<9) { i in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(pattern[i] == 1 ? Color.primary : Color.primary.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .opacity(progress > 0.5 ? 0.1 : 1.0)
                        .blur(radius: progress > 0.7 ? 5 : 0)
                }
            }
            
            Text("Recall the pattern")
                .font(.caption)
                .opacity(progress > 0.5 ? 1.0 : 0)
        }
    }
}

struct FocusDistractionExperience: View {
    let progress: Double
    @State private var distract = false
    
    var body: some View {
        ZStack {
            Text("Focus on this core message")
                .font(.title2)
                .opacity(1.0 - (progress * 0.7))
            
            ForEach(0..<12) { i in
                Circle()
                    .fill(Color.accentColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .offset(x: distract ? CGFloat.random(in: -200...200) : 0, 
                            y: distract ? CGFloat.random(in: -400...400) : 0)
                    .opacity(progress)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                distract = true
            }
        }
    }
}

struct CognitiveLoadExperience: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<Int(5 + (progress * 15)), id: \.self) { i in
                HStack {
                    Image(systemName: "info.circle")
                    Text("Requirement #\(i): Ensure that all parameters are calibrated.")
                        .font(.system(size: 14 - (progress * 2)))
                }
                .padding(8)
                .background(Color.primary.opacity(0.05))
                .cornerRadius(4)
            }
        }
        .padding(20)
    }
}

struct InteractionPrecisionExperience: View {
    let progress: Double
    @State private var drift = false
    
    var body: some View {
        VStack(spacing: 40) {
            Button(action: {}) {
                Circle()
                    .fill(Color.primary.opacity(0.1))
                    .frame(width: 80 - (progress * 40), height: 80 - (progress * 40))
                    .overlay(Text("Tap").font(.caption))
            }
            .offset(x: drift ? (progress * 20) : 0, y: drift ? (progress * -20) : 0)
            
            Text("Targets are shrinking and shifting.")
                .font(.caption)
                .opacity(progress)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                drift = true
            }
        }
    }
}
