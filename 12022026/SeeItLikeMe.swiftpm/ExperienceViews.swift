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
    
    // Derived state for cleaner view logic
    var isIntro: Bool {
        if case .focused = store.hubState { return true }
        return false
    }
    
    var isReflecting: Bool {
        if case .integrating = store.hubState { return true }
        return false
    }
    
    var body: some View {
        ZStack {
            // LAYER 1: Active Experience (Always visible once started, reduced during intro/reflection)
            if !isIntro {
                ExperienceContent(kind: kind, isReflecting: isReflecting)
                    .transition(.opacity.animation(.easeInOut(duration: 1.0)))
                    .blur(radius: isReflecting ? 15 : 0) // Blur during reflection
                    .saturation(isReflecting ? 0.5 : 1.0)
            }
            
            // LAYER 2: Intro Overlay
            if isIntro {
                ExperienceIntroView(kind: kind)
                    .transition(.opacity.combined(with: .scale(scale: 1.05)))
                    .zIndex(2)
            }
            
            // LAYER 3: Reflection Overlay
            if isReflecting {
                ExperienceReflectionView(kind: kind)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(3)
            }
            
            // Back Button (Top Left)
            // Available in all states, exits gracefully
            VStack {
                HStack {
                    BackButton {
                        // Clean exit logic handled by Models based on current state
                        if isReflecting {
                           store.finishJourney(kind)
                        } else {
                           // If active/intro, just leave
                           withAnimation(.easeInOut) {
                               store.flow = .hub
                               store.hubState = .idle
                           }
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 20)
            .padding(.leading, 20)
            .zIndex(100)
        }
    }
}

// MARK: - Intro View
struct ExperienceIntroView: View {
    let kind: ExperienceKind
    @EnvironmentObject var store: AppStore
    @State private var appear = false
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: kind.icon)
                    .font(.system(size: 60, weight: .thin))
                    .foregroundColor(.primary.opacity(0.8))
                    .scaleEffect(appear ? 1.0 : 0.8)
                    .opacity(appear ? 1.0 : 0)
                
                VStack(spacing: 16) {
                    Text(kind.rawValue)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text(introText)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .foregroundColor(.secondary)
                }
                .offset(y: appear ? 0 : 20)
                .opacity(appear ? 1.0 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                appear = true
            }
            // Auto-advance to active after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                store.startActiveExperience(kind)
            }
        }
    }
    
    private var introText: String {
        switch kind {
        case .visualStrain: return "Read the text as the environment changes."
        case .colorPerception: return "Tap the color that looks different."
        case .focusTunnel: return "Keep watching the center context."
        case .readingStability: return "Try to read the moving text."
        case .memoryLoad: return "Remember the pattern, then find it again."
        case .focusDistraction: return "Ignore the shapes. Focus on the message."
        case .cognitiveLoad: return "Clear the tasks as they appear."
        case .interactionPrecision: return "Tap the target as often as you can."
        }
    }
}

// MARK: - Reflection View
struct ExperienceReflectionView: View {
    let kind: ExperienceKind
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        ZStack {
            // Dimmed backdrop
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    // Optional: Tap outside to close? 
                    // No, keeping it explicit with the button.
                }
            
            VStack(spacing: 30) {
                Text(kind.rawValue)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(reflectionText)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                
                Button(action: {
                    store.finishJourney(kind)
                }) {
                    Text("Complete")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(Capsule().fill(Color.blue))
                }
            }
            .padding(40)
            .background(.regularMaterial)
            .cornerRadius(24)
            .shadow(radius: 20)
            .padding(20)
        }
    }
    
    private var reflectionText: String {
        switch kind {
        case .visualStrain: 
            return "Visual fatigue accumulates unnoticed. Even small contrast reductions force the eyes to work significantly harder, leading to 'computer vision syndrome'."
        case .colorPerception:
            return "When color sensitivity is reduced, distinguishing elements becomes a guessing game. Reliance on color alone excludes."
        case .focusTunnel:
            return "Peripheral vision provides critical context. When it's lost, we lose the ability to anticipate and orient ourselves."
        case .readingStability:
            return "Reading requires the eyes to anchor. When that anchor moves (like in nystagmus), comprehension drops while effort spikes."
        case .memoryLoad:
            return "Working memory is fragile. A single interruption can wipe it clean, forcing a complete restart of the task."
        case .focusDistraction:
            return "Motion captures attention involuntarily. Trying to ignore it is an active, exhausting cognitive process."
        case .cognitiveLoad:
            return "When instructions pile up faster than we can process them, anxiety replaces logic. Simplicity is a requirement, not a style."
        case .interactionPrecision:
            return "Motor impairments turn simple taps into frustrations. Generous touch targets are not a luxury; they are a necessity."
        }
    }
}

struct ExperienceContent: View {
    let kind: ExperienceKind
    let isReflecting: Bool
    
    // We pass isReflecting so experiences can pause/slow down if they want,
    // though the wrapper already blurs them.
    
    var body: some View {
        Group {
            switch kind {
            case .visualStrain: VisualStrainExperience(isReflecting: isReflecting)
            case .colorPerception: ColorPerceptionExperience(isReflecting: isReflecting)
            case .focusTunnel: FocusTunnelExperience(isReflecting: isReflecting)
            case .readingStability: ReadingStabilityExperience(isReflecting: isReflecting)
            case .memoryLoad: MemoryLoadExperience(isReflecting: isReflecting)
            case .focusDistraction: FocusDistractionExperience(isReflecting: isReflecting)
            case .cognitiveLoad: CognitiveLoadExperience(isReflecting: isReflecting)
            case .interactionPrecision: InteractionPrecisionExperience(isReflecting: isReflecting)
            }
        }
    }
}

// --- Experience Implementations ---

struct VisualStrainExperience: View {
    let isReflecting: Bool
    @State private var startTime = Date()
    @State private var now = Date()
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var progress: Double {
        // Accumulate strain over 60 seconds
        let p = now.timeIntervalSince(startTime) / 60.0
        return min(p, 1.0)
    }
    
    private let contentText = """
    Reading requires a stable visual environment.
    
    When contrast is reduced, the eyes must work harder to distinguish shapes.
    
    When brightness is uneven, the pupil constantly adjusts, leading to fatigue.
    
    When clarity drifts, the lens muscle strains to find focus.
    
    Subtle changes, over time, create a cumulative burden that is hard to ignore but easy to underestimate.
    
    The effort to maintain focus drains mental energy, leaving less capacity for comprehension and decision making.
    """
    
    var body: some View {
        ZStack {
            // Layer 1: Background degrading to mid-grey (low contrast)
            Color.white.opacity(1.0 - (progress * 0.5)) // Fades to grey
                .ignoresSafeArea()
            Color.black.opacity(progress * 0.1) // Adds muddy tone
                .ignoresSafeArea()
            
            // Layer 2: Uneven Brightness (Vignette + Blobs)
            GeometryReader { geo in
                ZStack {
                    // Dark corners
                    RadialGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(progress * 0.4)]),
                        center: .center,
                        startRadius: geo.size.width * 0.3,
                        endRadius: geo.size.height * 0.8
                    )
                    
                    // Bright/Dark Spots drifting
                    Circle()
                        .fill(Color.white.opacity(progress * 0.15))
                        .frame(width: 300, height: 300)
                        .blur(radius: 50)
                        .offset(x: sin(now.timeIntervalSince1970 * 0.5) * 100,
                                y: cos(now.timeIntervalSince1970 * 0.3) * 100)
                }
            }
            .ignoresSafeArea()
            
            // Layer 3: Text Content
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(contentText.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                        Text(paragraph)
                            .font(.system(size: 18, weight: .regular, design: .serif))
                            .lineSpacing(8)
                            .foregroundColor(
                                // Text fades from Black to Dark Grey
                                Color.black.opacity(0.8 - (progress * 0.5))
                            )
                            // Text gets slightly blurry
                            .blur(radius: progress * 1.5)
                            .padding(.horizontal, 40)
                    }
                }
                .padding(.vertical, 80)
            }
            // Disallow scrolling as strain increases? No, keeping it usable but hard.
            
            // Layer 4: Visual Noise / Grain
            if progress > 0.1 {
                Color.white.opacity(0.05)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        // Simple static noise simulation
                        GeometryReader { geo in
                            Path { path in
                                for _ in 0..<Int(progress * 200) {
                                    let x = Double.random(in: 0...Double(geo.size.width))
                                    let y = Double.random(in: 0...Double(geo.size.height))
                                    path.addRect(CGRect(x: x, y: y, width: 2, height: 2))
                                }
                            }
                            .fill(Color.black.opacity(0.2))
                        }
                    )
                    .ignoresSafeArea()
            }
        }
        .onReceive(timer) { input in
            guard !isReflecting else { return }
            now = input
        }
        .onAppear {
            startTime = Date()
        }
    }
}



struct ColorPerceptionExperience: View {
    let isReflecting: Bool
    
    // Game State
    @State private var targetIndex: Int = 0
    @State private var baseColor: Color = .blue
    @State private var level: Int = 1
    @State private var flashIndex: Int? = nil // For feedback
    @State private var isCorrect: Bool? = nil
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    
    var difficulty: Double {
        // As level increases, difficulty 0->1
        // Level 1: Diff 0.2 (Easy). Level 10: Diff 0.01 (Hard)
        return min(Double(level) / 10.0, 1.0)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Find the different shade")
                .font(.caption)
                .textCase(.uppercase)
                .kerning(2)
                .opacity(0.6)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<9) { index in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color(for: index))
                        .aspectRatio(1.0, contentMode: .fit)
                        // Feedback overlay
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 4)
                                .foregroundColor(flashIndex == index ? (isCorrect == true ? .green : .red) : .clear)
                        )
                        .scaleEffect(flashIndex == index ? 0.95 : 1.0)
                        .onTapGesture {
                            handleTap(index)
                        }
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: flashIndex)
                }
            }
            .padding(40)
            
            Text("Round \(level)")
                .font(.caption.monospacedDigit())
                .foregroundColor(.secondary)
        }
        .onAppear {
            generateRound()
        }
    }
    
    private func color(for index: Int) -> Color {
        if index == targetIndex {
            // Calculate difference
            // Level 1 (Diff 0.0) -> Hue Shift 0.15
            // Level 10 (Diff 1.0) -> Hue Shift 0.005
            let shift = 0.15 - (difficulty * 0.145)
            
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            UIColor(baseColor).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            return Color(hue: h + shift, saturation: s, brightness: b)
        }
        return baseColor
    }
    
    private func handleTap(_ index: Int) {
        guard flashIndex == nil else { return } // Prevent spam
        
        flashIndex = index
        isCorrect = (index == targetIndex)
        
        let delay = 0.6
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            flashIndex = nil
            if isCorrect == true {
                level += 1
                generateRound()
            } else {
                // Keep same level, new colors
                generateRound()
            }
        }
    }
    
    private func generateRound() {
        targetIndex = Int.random(in: 0..<9)
        baseColor = Color(
            hue: Double.random(in: 0...1),
            saturation: 0.7,
            brightness: 0.9
        )
    }
}

struct FocusTunnelExperience: View {
    let isReflecting: Bool
    @State private var startTime = Date()
    @State private var now = Date()
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var progress: Double {
        // Narrow over 30 seconds
        let p = now.timeIntervalSince(startTime) / 30.0
        return min(p, 1.0)
    }
    
    var body: some View {
        ZStack {
            // Content Layer: Grid of Context Info
            GeometryReader { geo in
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                    ForEach(0..<20) { i in
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text("Contextual Alert \(i)")
                                .font(.caption)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding()
                
                // Vital warning labels on the far edges
                Text("WARNING: System Failure")
                    .foregroundColor(.red)
                    .position(x: 50, y: geo.size.height / 2)
                Text("BATTERY CRITICAL")
                    .foregroundColor(.orange)
                    .position(x: geo.size.width - 50, y: geo.size.height / 2)
            }
            .blur(radius: isReflecting ? 10 : 0)
            
            // Mask Layer
            GeometryReader { geo in
                let center = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
                let maxRadius = max(geo.size.width, geo.size.height)
                let currentRadius = maxRadius * (1.1 - (progress * 0.95)) // Shrink to 15%
                
                ZStack {
                    // Dark Outer
                    Color.black.opacity(0.95)
                        .mask(
                            Rectangle()
                                .overlay(
                                    Circle()
                                        .frame(width: max(50, currentRadius), height: max(50, currentRadius))
                                        .blendMode(.destinationOut)
                                )
                        )
                    
                    // Tunnel edges (Gradient)
                    Circle()
                        .strokeBorder(
                            RadialGradient(gradient: Gradient(colors: [.clear, .black]), center: .center, startRadius: 0, endRadius: max(25, currentRadius/2)),
                            lineWidth: currentRadius
                        )
                        .frame(width: currentRadius, height: currentRadius)
                }
            }
            .ignoresSafeArea()
        }
        .onAppear { startTime = Date() }
        .onReceive(timer) { input in
            guard !isReflecting else { return }
            now = input
        }
    }
}

struct ReadingStabilityExperience: View {
    let isReflecting: Bool
    @State private var time: Double = 0
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 30) {
                ForEach(0..<12) { i in
                    Text("Continuous text requires a stable baseline. When elements shift, the cognitive cost of tracking increases significantly. This simulation mimics nystagmus and other instability conditions.")
                        .font(.title3)
                        .lineLimit(2)
                        .offset(x: xOffset(i), y: yOffset(i))
                        .rotationEffect(.degrees(rotation(i)))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(40)
            .frame(height: geo.size.height)
        }
        .onReceive(timer) { _ in
            guard !isReflecting else { return }
            time += 0.05
        }
    }
    
    // Chaotic Physics
    func xOffset(_ i: Int) -> CGFloat {
        // Drifts left/right
        return sin(time + Double(i)) * 15 + cos(time * 0.5) * 10
    }
    
    func yOffset(_ i: Int) -> CGFloat {
        // Bobs up/down randomly
        return sin(time * 1.5 + Double(i)*0.2) * 8
    }
    
    func rotation(_ i: Int) -> Double {
        // Subtle tilt
        return sin(time * 0.8 + Double(i)) * 2
    }
}

struct MemoryLoadExperience: View {
    let isReflecting: Bool
    @State private var pattern: [Int] = (0..<9).map { _ in Int.random(in: 0...1) }
    @State private var phase: Int = 0 // 0: Observe, 1: Noise, 2: Recall
    @State private var userPattern: [Int] = Array(repeating: 0, count: 9)
    
    // Timer for phase transitions
    @State private var time: Double = 0
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 40) {
            Text(statusText)
                .font(.title3)
                .animation(.easeInOut, value: phase)
            
            ZStack {
                // The Grid
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(80), spacing: 16), count: 3), spacing: 16) {
                    ForEach(0..<9) { i in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(cellColor(at: i))
                            .frame(width: 80, height: 80)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.primary.opacity(0.1), lineWidth: 1))
                            .onTapGesture {
                                if phase == 2 {
                                    userPattern[i] = userPattern[i] == 1 ? 0 : 1
                                }
                            }
                            .animation(.easeInOut(duration: 0.3), value: userPattern)
                    }
                }
                .opacity(phase == 1 ? 0.1 : 1.0)
                .blur(radius: phase == 1 ? 10 : 0)
                
                // Distraction Phase
                if phase == 1 {
                    GeometryReader { geo in
                        ForEach(0..<20) { _ in
                            Circle()
                                .fill(Color.primary.opacity(0.1))
                                .frame(width: 50, height: 50)
                                .offset(x: CGFloat.random(in: 0...geo.size.width),
                                        y: CGFloat.random(in: 0...geo.size.height))
                                .animation(
                                    Animation.spring().repeatForever().speed(Double.random(in: 0.5...2.0)),
                                    value: time
                                )
                        }
                    }
                }
            }
            .frame(width: 300, height: 300)
            
            if phase == 2 {
                Button("Check Memory") {
                    // Start over with new pattern
                    withAnimation {
                        pattern = (0..<9).map { _ in Int.random(in: 0...1) }
                        userPattern = Array(repeating: 0, count: 9)
                        phase = 0
                        time = 0
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .onReceive(timer) { _ in
            guard !isReflecting else { return }
            time += 1
            if time == 5 && phase == 0 { withAnimation { phase = 1 } }
            if time == 10 && phase == 1 { withAnimation { phase = 2 } }
        }
    }
    
    var statusText: String {
        switch phase {
        case 0: return "Memorize the pattern (5s)"
        case 1: return "Wait..."
        case 2: return "Recreate the pattern"
        default: return ""
        }
    }
    
    func cellColor(at i: Int) -> Color {
        if phase == 0 {
            return pattern[i] == 1 ? Color.blue : Color.gray.opacity(0.1)
        } else if phase == 2 {
            return userPattern[i] == 1 ? Color.blue : Color.gray.opacity(0.1)
        }
        return Color.gray.opacity(0.1)
    }
}

struct FocusDistractionExperience: View {
    let isReflecting: Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background Layer (Distractors)
                ForEach(0..<15) { i in
                    DistractorCircle(isReflecting: isReflecting, index: i, size: geo.size)
                }
                
                // Foreground Layer (Task)
                VStack(spacing: 20) {
                    Text("Read this passage carefully")
                        .font(.headline)
                        .opacity(0.5)
                    
                    Text("In an environment of high kinetic distraction, the ability to maintain focal attention is compromised. The brain's visual system is hardwired to detect motion, overriding voluntary focus commands. This creates a constant tug-of-war between intent and instinct.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(30)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                }
                .frame(width: 300)
                .position(x: geo.size.width/2, y: geo.size.height/2)
            }
        }
    }
}

struct DistractorCircle: View {
    let isReflecting: Bool
    let index: Int
    let size: CGSize
    @State private var position: CGPoint = .zero
    
    var body: some View {
        Circle()
            .fill(Color.accentColor.opacity(0.3))
            .frame(width: CGFloat.random(in: 30...80), height: CGFloat.random(in: 30...80))
            .position(position)
            .onAppear {
                position = randomPosition()
                animate()
            }
    }
    
    func randomPosition() -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: 0...size.width),
            y: CGFloat.random(in: 0...size.height)
        )
    }
    
    func animate() {
        guard !isReflecting else { return }
        
        withAnimation(
            Animation.linear(duration: Double.random(in: 3.0...10.0))
                .repeatForever(autoreverses: false)
        ) {
            position = randomPosition()
        }
    }
}

struct CognitiveLoadExperience: View {
    let isReflecting: Bool
    @State private var tasks: [CognitiveTask] = []
    let timer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect()
    
    struct CognitiveTask: Identifiable {
        let id = UUID()
        let title: String
        let color: Color
        var offset: CGSize
    }
    
    var body: some View {
        ZStack {
            // Base layer
            Color.white.opacity(0.1).ignoresSafeArea()
            
            // Task Stack
            ForEach(tasks) { task in
                VStack(alignment: .leading) {
                    HStack {
                        Circle().fill(task.color).frame(width: 12, height: 12)
                        Text(task.title).bold()
                        Spacer()
                    }
                    Text("Review required. Tap to dismiss.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("Dismiss") {
                        dismiss(task)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(task.color.opacity(0.3))
                    .foregroundColor(.primary)
                }
                .padding()
                .frame(width: 250)
                .background(.regularMaterial)
                .cornerRadius(12)
                .shadow(radius: 5)
                .offset(task.offset)
                .transition(.scale.combined(with: .opacity))
                .zIndex(Double(tasks.firstIndex(where: {$0.id == task.id}) ?? 0))
            }
            
            Text("Tasks: \(tasks.count)")
                .font(.largeTitle.bold())
                .foregroundColor(tasks.count > 5 ? .red : .primary)
                .position(x: 60, y: 60)
        }
        .onReceive(timer) { _ in
            guard !isReflecting else { return }
            addTask()
        }
        .onAppear {
            addTask()
        }
    }
    
    func addTask() {
        let titles = ["Email", "Slack", "Update", "Alert", "Call"]
        let colors: [Color] = [.blue, .orange, .red, .green, .purple]
        
        let newTask = CognitiveTask(
            title: titles.randomElement()!,
            color: colors.randomElement()!,
            offset: CGSize(
                width: CGFloat.random(in: -50...50),
                height: CGFloat.random(in: -50...50)
            )
        )
        withAnimation(.spring()) {
            tasks.append(newTask)
        }
    }
    
    func dismiss(_ task: CognitiveTask) {
        if let index = tasks.firstIndex(where: {$0.id == task.id}) {
            withAnimation {
                tasks.remove(at: index)
            }
        }
    }
}

struct InteractionPrecisionExperience: View {
    let isReflecting: Bool
    @State private var position: CGPoint = CGPoint(x: 200, y: 300)
    @State private var targetScale: CGFloat = 1.0
    @State private var tapFeedback: Color = .clear
    
    let timer = Timer.publish(every: 0.8, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background visual cue of "where it should be"
                Circle()
                    .stroke(Color.primary.opacity(0.1), lineWidth: 2)
                    .frame(width: 60, height: 60)
                    .position(position)
                
                // Active Button
                Button(action: {
                    handleTap()
                }) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 60 * targetScale, height: 60 * targetScale)
                        .overlay(Circle().fill(tapFeedback))
                        .shadow(radius: 5)
                }
                .position(position)
                .animation(.easeInOut(duration: 0.7), value: position) // Drifts/Lags
            }
            .background(Color.clear.contentShape(Rectangle()).onTapGesture {
                // Missed tap
                withAnimation { tapFeedback = .red.opacity(0.5) }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { tapFeedback = .clear }
            })
        }
        .onReceive(timer) { _ in
            guard !isReflecting else { return }
            // Shift position randomly
            let x = CGFloat.random(in: 50...UIScreen.main.bounds.width-50)
            let y = CGFloat.random(in: 100...UIScreen.main.bounds.height-200)
            position = CGPoint(x: x, y: y)
            targetScale = CGFloat.random(in: 0.6...1.0)
        }
    }
    
    func handleTap() {
        // Success
        withAnimation { tapFeedback = .green.opacity(0.5) }
        
        // Simulating input delay? 
        // Logic: Tap visual is instant, but next drift is delayed?
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tapFeedback = .clear
        }
    }
}
