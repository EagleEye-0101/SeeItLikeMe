import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct LaunchExperienceView: View {
    let onComplete: () -> Void
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var offsetY: CGFloat = 60
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 24) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 90))
                    .foregroundColor(.accentColor)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("See It Like Me")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .offset(y: offsetY)
                
                Text("Empathy through interface feeling.")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .opacity(opacity)
                    .offset(y: offsetY)
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                Text("Understanding how design shapes our digital experience.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(opacity)
                    .offset(y: offsetY)
                
                PrimaryButton(title: "Begin", action: {
                    onComplete()
                })
                .opacity(opacity)
                .offset(y: offsetY)
            }
            .padding(.bottom, 60)
        }
        .padding()
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).delay(0.3)) {
                opacity = 1
                scale = 1
                offsetY = 0
            }
        }
    }
}