import SwiftUI
import Foundation

struct VisualStrainView: View {
    @State private var improveDesign = false

    private let sampleText = """
This paragraph uses bright colors, light text, and smaller type. It asks your eyes to work harder than they need to, especially over time.
"""

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    instructionSection
                    simulationSection
                    reflectionSection
                }
                .padding()
            }
        }
        .animation(.easeInOut(duration: 0.4), value: improveDesign)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Toggle(isOn: $improveDesign) {
                    Image(systemName: improveDesign ? "sun.max.fill" : "sun.max")
                }
                .toggleStyle(.switch)
                .labelsHidden()
                .accessibilityLabel("Toggle comfortable design")
                .accessibilityHint("Switch between a visually straining layout and a more comfortable one.")
            }
        }
    }

    private var instructionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Instruction", systemImage: "text.magnifyingglass")

            Text("Try reading the paragraph below. Notice how your eyes feel, then switch to the more comfortable version.")
                .font(.body)
                .foregroundColor(.primary)
        }
    }

    private var simulationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Simulation", systemImage: "eye")

            Text(sampleText)
                .font(improveDesign ? .body : .footnote)
                .foregroundColor(textColor)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(containerBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(borderColor, lineWidth: 1)
                )
                .accessibilityLabel("Sample paragraph demonstrating visual strain.")
        }
    }

    private var reflectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Reflection", systemImage: "bubble.left.and.bubble.right")

            Text("""
Even when text is technically “readable,” choices like low contrast, bright backgrounds, and small type can quietly drain energy. Designing with generous contrast and comfortable sizing makes reading easier for many more people.
""")
            .font(.body)
            .foregroundColor(.primary)
        }
    }

    private var backgroundColor: Color {
        improveDesign ? Color(.systemBackground) : Color.yellow.opacity(0.5)
    }

    private var textColor: Color {
        improveDesign ? .primary : Color.gray.opacity(0.7)
    }

    private var containerBackground: Color {
        improveDesign ? Color(.secondarySystemBackground) : Color.white.opacity(0.9)
    }

    private var borderColor: Color {
        improveDesign ? Color.clear : Color.gray.opacity(0.3)
    }
}

struct VisualStrainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VisualStrainView()
                .navigationTitle("Visual Strain")
        }
    }
}