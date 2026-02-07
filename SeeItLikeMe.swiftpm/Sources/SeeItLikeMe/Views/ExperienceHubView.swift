import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct ExperienceHubView: View {
    let hubState: HubState
    let completedExperiences: Set<ExperienceKind>
    let onFocus: (ExperienceKind) -> Void
    let onImmerse: (ExperienceKind) -> Void
    let onIntegrate: (ExperienceKind) -> Void
    let onSynthesize: () -> Void
    
    @State private var ambientOffset: CGFloat = 0
    @State private var gradientAngle: Double = 0
    @State private var floatingElements: [FloatingElement] = []
    
    struct FloatingElement: Identifiable {
        let id = UUID()
        let position: CGPoint
        let size: CGFloat
        let opacity: Double
        let delay: Double
    }
    
    var body: some View {
        ZStack {
            // Ambient gradient background
            AngularGradient(
                gradient: Gradient(colors: [
                    Color.accentColor.opacity(0.1),
                    Color.blue.opacity(0.05),
                    Color.purple.opacity(0.08),
                    Color.accentColor.opacity(0.1)
                ]),
                center: .center,
                angle: .degrees(gradientAngle)
            )
            .ignoresSafeArea()
            
            // Floating ambient elements
            ForEach(floatingElements) { element in
                Circle()
                    .fill(Color.secondary.opacity(element.opacity))
                    .frame(width: element.size, height: element.size)
                    .position(element.position)
            }
            
            // Experience nodes
            VStack(spacing: 40) {
                Spacer()
                
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 140, maximum: 200), spacing: 25)
                ], spacing: 25) {
                    ForEach(ExperienceKind.allCases) { experience in
                        ExperienceNodeView(
                            experience: experience,
                            isCompleted: completedExperiences.contains(experience),
                            currentState: hubState,
                            onTap: {
                                switch hubState {
                                case .idle:
                                    onFocus(experience)
                                case .focused(let current) where current == experience:
                                    onImmerse(experience)
                                case .immersed(let current) where current == experience:
                                    onIntegrate(experience)
                                case .integrating(let current) where current == experience:
                                    if completedExperiences.count >= 3 {
                                        onSynthesize()
                                    }
                                default:
                                    break
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            
            // Persistent bottom dock
            ExperienceDockView(
                hubState: hubState,
                completedCount: completedExperiences.count,
                onShiftPerspective: {
                    if case .integrating = hubState {
                        onFocus(ExperienceKind.allCases.first!)
                    }
                }
            )
            .padding(.bottom, 20)
        }
        .onAppear {
            setupAmbientAnimations()
            generateFloatingElements()
        }
    }
    
    private func setupAmbientAnimations() {
        withAnimation(.easeInOut(duration: 30).repeatForever(autoreverses: true)) {
            ambientOffset = 20
        }
        
        withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
            gradientAngle = 360
        }
    }
    
    private func generateFloatingElements() {
        let elements = (0..<15).map { _ in
            FloatingElement(
                position: CGPoint(
                    x: CGFloat.random(in: 50...300),
                    y: CGFloat.random(in: 100...600)
                ),
                size: CGFloat.random(in: 4...12),
                opacity: Double.random(in: 0.05...0.15),
                delay: Double.random(in: 0...5)
            )
        }
        floatingElements = elements
    }
}