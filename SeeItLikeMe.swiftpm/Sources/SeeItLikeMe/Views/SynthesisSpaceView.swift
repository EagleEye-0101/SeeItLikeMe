import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct SynthesisSpaceView: View {
    let completedCount: Int
    let onRestart: () -> Void
    
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.9
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundColor(.accentColor)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("Integration Complete")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity(opacity)
                    .scaleEffect(scale)
                
                Text("Design shapes perception. Perception shapes experience. Experience shapes understanding.")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(opacity)
                
                Text("This experience is for awareness only and does not represent medical advice or diagnosis.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(opacity)
                    .padding(.top, 20)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            PrimaryButton(title: "Begin Again", action: {
                onRestart()
            })
            .padding(.bottom, 60)
        }
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
                opacity = 1
                scale = 1
            }
        }
    }
}