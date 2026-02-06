import SwiftUI
import Foundation

struct ReadingLoadView: View {
    @State private var animate = true
    @State private var offset: CGFloat = 0
    @State private var tracking: CGFloat = 0
    @State private var timer: Timer?

    private let sample = """
Subtle movement and spacing changes can make text feel slightly unstable. Your eyes must continually recalculate where each word will appear.
"""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                instructionSection
                simulationSection
                controlsSection
                reflectionSection
            }
            .padding()
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var instructionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Instruction", systemImage: "book")

            Text("Read the moving text for a few moments, then pause the motion and compare how it feels to follow.")
                .font(.body)
                .foregroundColor(.primary)
        }
    }

    private var simulationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Simulation", systemImage: "textformat")

            Text(sample)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
                .tracking(tracking)
                .offset(x: offset)
                .animation(.easeInOut(duration: 1.3), value: offset)
                .animation(.easeInOut(duration: 1.3), value: tracking)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground))
                )
                .accessibilityLabel("Paragraph with subtle motion and changing letter spacing.")
        }
    }

    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Controls", systemImage: "slider.horizontal.3")

            PrimaryButton(title: animate ? "Pause movement" : "Resume movement", systemImage: animate ? "pause.fill" : "play.fill") {
                animate.toggle()
                if animate {
                    startTimer()
                } else {
                    stopTimer()
                    offset = 0
                    tracking = 0
                }
            }
            .accessibilityHint("Toggle subtle motion and spacing changes in the text.")
        }
    }

    private var reflectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Reflection", systemImage: "bubble.left.and.bubble.right")

            Text("""
Even gentle animation can add cognitive load when it competes with reading. Giving people the option to pause motion, or avoiding unnecessary movement near text, can make content easier to follow.
""")
            .font(.body)
            .foregroundColor(.primary)
        }
    }

    private func startTimer() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1.3, repeats: true) { _ in
            guard animate else { return }
            withAnimation(.easeInOut(duration: 1.3)) {
                offset = offset == 0 ? 4 : 0
                tracking = tracking == 0 ? 1.2 : 0
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct ReadingLoadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReadingLoadView()
                .navigationTitle("Reading Load")
        }
    }
}