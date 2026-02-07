import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct OnboardingView: View {
    let currentPage: Int
    let onPageChange: (Int) -> Void
    
    @State private var opacity: Double = 0
    @State private var offsetY: CGFloat = 60
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 24) {
                switch currentPage {
                case 0:
                    onboardingPage1
                case 1:
                    onboardingPage2
                case 2:
                    onboardingPage3
                default:
                    EmptyView()
                }
            }
            
            Spacer()
            
            if currentPage < 2 {
                PrimaryButton(title: currentPage == 0 ? "Continue" : "Next", action: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        onPageChange(currentPage + 1)
                    }
                })
            } else {
                PrimaryButton(title: "Begin the Journey", action: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        onPageChange(3)
                    }
                })
            }
            .padding(.bottom, 60)
        }
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                opacity = 1
                offsetY = 0
            }
        }
    }
    
    private var onboardingPage1: some View {
        VStack(spacing: 24) {
            Image(systemName: "eye.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
                .scaleEffect(opacity)
            
            Text("Perception Shapes Experience")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .opacity(opacity)
                .offset(y: offsetY)
            
            Text("How interface design influences what we see, feel, and understand.")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .opacity(opacity)
                .offset(y: offsetY)
        }
    }
    
    private var onboardingPage2: some View {
        VStack(spacing: 24) {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
                .scaleEffect(opacity)
            
            Text("Subtle Changes, Profound Effects")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .opacity(opacity)
                .offset(y: offsetY)
            
            Text("These experiences may feel unfamiliar or uncomfortable. There is no right or wrong way to perceive.")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .opacity(opacity)
                .offset(y: offsetY)
        }
    }
    
    private var onboardingPage3: some View {
        VStack(spacing: 24) {
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
                .scaleEffect(opacity)
            
            Text("Ready to Begin?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .opacity(opacity)
                .offset(y: offsetY)
            
            Text("Explore how design choices shape human experience.")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .opacity(opacity)
                .offset(y: offsetY)
        }
    }
}