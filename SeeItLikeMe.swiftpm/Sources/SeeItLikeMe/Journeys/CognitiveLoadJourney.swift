import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct CognitiveLoadJourney: View {
    @Binding var hubState: HubState
    let onComplete: () -> Void
    
    @State private var phase: JourneyPhase = .orientation
    @State private var taskLayers: Int = 1
    @State private var instructionOpacity: Double = 1.0
    @State private var currentInstruction: String = ""
    
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
            
            VStack(spacing: 30) {
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
            Image(systemName: "cpu")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Mental Processing")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Manage multiple cognitive tasks simultaneously")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
        }
    }
    
    private var environmentalShiftView: some View {
        VStack(spacing: 25) {
            Text("Processing Layer \(taskLayers)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(currentInstruction)
                .font(.title2)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .opacity(instructionOpacity)
            
            taskVisualization
        }
    }
    
    private var immersiveInteractionView: some View {
        VStack(spacing: 20) {
            Text("Multiple Instructions")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Process layered information while tasks evolve")
                .font(.title2)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            layeredTasks
        }
    }
    
    private var integrationView: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 60))
                .foregroundColor(.primary)
            
            Text("Reflection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("How did increasing complexity affect your thinking?")
                .font(.title2)
                .foregroundColor(.primary.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    private var taskVisualization: some View {
        VStack(spacing: 15) {
            ForEach(0..<taskLayers, id: \.self) { index in
                Capsule()
                    .fill(Color.accentColor.opacity(0.3 + Double(index) * 0.2))
                    .frame(height: 20)
                    .overlay(
                        Text("Task \(index + 1)")
                            .font(.caption)
                            .foregroundColor(.primary)
                    )
            }
        }
        .frame(maxWidth: 200)
    }
    
    private var layeredTasks: some View {
        VStack(spacing: 12) {
            ForEach(0..<3, id: \.self) { layer in
                HStack {
                    Capsule()
                        .fill(layer < taskLayers ? Color.accentColor : Color.secondary.opacity(0.3))
                        .frame(height: 16)
                    
                    Text(layerInstructions[layer])
                        .font(.caption)
                        .foregroundColor(layer < taskLayers ? .primary : .secondary)
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: 250)
    }
    
    private func startJourney() {
        let instructions = [
            "Count the circles",
            "Remember the sequence",
            "Track the movement",
            "Calculate the sum",
            "Monitor the changes"
        ]
        
        // Phase 1: Orientation (5 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                phase = .environmentalShift
            }
            
            // Phase 2: Environmental shift (18 seconds)
            for i in 1...3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i * 6)) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        taskLayers = i + 1
                        currentInstruction = instructions[i]
                    }
                    
                    // Fade instructions
                    withAnimation(.easeInOut(duration: 3)) {
                        instructionOpacity = 0.4
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            instructionOpacity = 1.0
                        }
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
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                        onComplete()
                    }
                }
            }
        }
    }
    
    private let layerInstructions = [
        "Primary task focus",
        "Secondary consideration", 
        "Background monitoring"
    ]
}