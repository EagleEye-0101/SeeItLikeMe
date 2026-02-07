import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct ContentView: View {
    @State private var flow: AppFlow = .onboarding(page: 0)
    @State private var hubState: HubState = .idle
    @State private var completedExperiences: Set<ExperienceKind> = []
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            switch flow {
            case .onboarding(let page):
                OnboardingView(
                    currentPage: page,
                    onPageChange: { newPage in
                        if newPage < 3 {
                            flow = .onboarding(page: newPage)
                        } else {
                            flow = .hub(.idle)
                        }
                    }
                )
                
            case .hub(_):
                ExperienceHubView(
                    hubState: hubState,
                    completedExperiences: completedExperiences,
                    onFocus: { experience in
                        withAnimation(.easeInOut(duration: 0.8)) {
                            hubState = .focused(experience)
                        }
                    },
                    onImmerse: { experience in
                        withAnimation(.easeInOut(duration: 1.0)) {
                            hubState = .immersed(experience)
                        }
                    },
                    onIntegrate: { experience in
                        withAnimation(.easeInOut(duration: 1.2)) {
                            hubState = .integrating(experience)
                            completedExperiences.insert(experience)
                        }
                    },
                    onSynthesize: {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            flow = .synthesis
                        }
                    }
                )
                
            case .synthesis:
                SynthesisSpaceView(
                    completedCount: completedExperiences.count,
                    onRestart: {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            flow = .onboarding(page: 0)
                            hubState = .idle
                            completedExperiences.removeAll()
                        }
                    }
                )
            }
        }
        .animation(.easeInOut(duration: 0.6), value: flow)
    }
}