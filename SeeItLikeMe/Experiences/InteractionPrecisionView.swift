import SwiftUI
import Foundation

struct InteractionPrecisionView: View {
    @State private var improvedLayout = false
    @State private var hits = 0
    @State private var misses = 0
    @State private var isProcessingTap = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                instructionSection
                simulationSection
                statsSection
                reflectionSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Toggle(isOn: $improvedLayout) {
                    Image(systemName: improvedLayout ? "rectangle.and.hand.point.up.left.fill" : "rectangle.and.hand.point.up.left")
                }
                .toggleStyle(.switch)
                .labelsHidden()
                .accessibilityLabel("Toggle comfortable target layout")
                .accessibilityHint("Switch between tiny crowded targets and larger, well-spaced targets.")
            }
        }
    }

    private var instructionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Instruction", systemImage: "hand.tap")

            Text("Try tapping the highlighted targets. Notice how accurate and relaxed your taps feel before and after improving the layout.")
                .font(.body)
                .foregroundColor(.primary)
        }
    }

    private var simulationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Simulation", systemImage: "square.grid.3x3")

            VStack(spacing: improvedLayout ? 16 : 4) {
                ForEach(0..<3) { _ in
                    HStack(spacing: improvedLayout ? 16 : 4) {
                        ForEach(0..<3) { _ in
                            targetButton
                        }
                    }
                }
            }
            .padding(improvedLayout ? 16 : 4)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.secondarySystemBackground))
            )
        }
    }

    private var targetButton: some View {
        Button {
            guard !isProcessingTap else { return }
            isProcessingTap = true

            // Simulate a delayed response to taps
            DispatchQueue.main.asyncAfter(deadline: .now() + (improvedLayout ? 0.05 : 0.3)) {
                if Bool.random() || improvedLayout {
                    hits += 1
                } else {
                    misses += 1
                }
                isProcessingTap = false
            }
        } label: {
            RoundedRectangle(cornerRadius: improvedLayout ? 12 : 4)
                .fill(isProcessingTap ? Color.gray.opacity(0.4) : Color.accentColor)
                .frame(width: improvedLayout ? 70 : 28, height: improvedLayout ? 44 : 22)
                .overlay(
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: improvedLayout ? 18 : 10))
                        .foregroundColor(.white)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Tap target")
        .accessibilityHint("Records a tap to show how precise interactions feel.")
    }

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "How it felt", systemImage: "chart.bar.fill")

            HStack(spacing: 16) {
                statPill(label: "Hits", value: hits, color: .green)
                statPill(label: "Misses", value: misses, color: .red)
            }

            Button {
                hits = 0
                misses = 0
            } label: {
                Text("Reset counts")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.accentColor)
            }
            .accessibilityLabel("Reset hit and miss counts")
        }
    }

    private func statPill(label: String, value: Int, color: Color) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text("\(value)")
                .font(.headline)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(color.opacity(0.12))
        )
        .foregroundColor(color)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }

    private var reflectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Reflection", systemImage: "bubble.left.and.bubble.right")

            Text("""
Tiny, tightly packed targets demand fine motor control and patience, especially when responses feel delayed. Generous hit areas, spacing, and responsive feedback make interactions more forgiving and welcoming.
""")
            .font(.body)
            .foregroundColor(.primary)
        }
    }
}

struct InteractionPrecisionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            InteractionPrecisionView()
                .navigationTitle("Interaction Precision")
        }
    }
}