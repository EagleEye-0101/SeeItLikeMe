import SwiftUI
import Foundation

struct MotionSensitivityView: View {
    @State private var animateBackground = true
    @State private var floating = false

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    instructionSection
                    simulationSection
                    controlsSection
                    reflectionSection
                }
                .padding()
            }
        }
        .onAppear {
            withAnimation(SafeAnimation.slowPulsing) {
                floating = true
            }
        }
        .onDisappear {
            floating = false
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var background: some View {
        LinearGradient(
            colors: animateBackground
                ? [Color.blue.opacity(0.25), Color.purple.opacity(0.25)]
                : [Color(.systemBackground), Color(.systemBackground)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .animation(SafeAnimation.slowPulsing, value: animateBackground)
    }

    private var instructionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Instruction", systemImage: "waveform.path")

            Text("Watch the gently moving shapes, then pause the motion and notice how your attention changes.")
                .font(.body)
                .foregroundColor(.primary)
        }
    }

    private var simulationSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.secondarySystemBackground))
                .frame(maxWidth: .infinity, minHeight: 220)

            ZStack {
                floatingCircle(size: 90, color: .blue.opacity(0.6), x: -60, y: floating ? -20 : -10)
                floatingCircle(size: 70, color: .purple.opacity(0.5), x: 40, y: floating ? 25 : 10)
                floatingCircle(size: 55, color: .mint.opacity(0.6), x: floating ? -10 : 5, y: 50)
            }
            .accessibilityHidden(true)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Gently moving shapes simulating constant background motion.")
    }

    private func floatingCircle(size: CGFloat, color: Color, x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .offset(x: x, y: y)
            .scaleEffect(floating ? 1.06 : 0.94)
            .animation(SafeAnimation.slowPulsing, value: floating)
    }

    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Controls", systemImage: "slider.horizontal.3")

            PrimaryButton(title: animateBackground ? "Reduce motion" : "Restore motion", systemImage: animateBackground ? "pause.circle.fill" : "play.circle.fill") {
                animateBackground.toggle()
                withAnimation(SafeAnimation.slowPulsing) {
                    floating.toggle()
                }
            }
            .accessibilityHint("Toggle gentle background motion.")
        }
    }

    private var reflectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Reflection", systemImage: "bubble.left.and.bubble.right")

            Text("""
Continuous motion can quietly pull attention away from what matters, and may feel uncomfortable for some people. Offering calm defaults and a clear way to reduce movement helps more people stay present with the content.
""")
            .font(.body)
            .foregroundColor(.primary)
        }
    }
}

struct MotionSensitivityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MotionSensitivityView()
                .navigationTitle("Motion Sensitivity")
        }
    }
}