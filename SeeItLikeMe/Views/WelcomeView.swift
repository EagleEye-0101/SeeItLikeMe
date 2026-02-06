import SwiftUI
import Foundation

struct WelcomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("See It Like Me")
                        .font(.largeTitle.weight(.bold))
                        .multilineTextAlignment(.leading)
                        .accessibilityAddTraits(.isHeader)

                    Text("Explore how small interface choices can change comfort, focus, and accessibility — all through short, offline experiences.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "What you'll do", systemImage: "sparkles")

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Try four tiny experiences that gently bend the rules of good design.", systemImage: "circle.grid.2x2")
                        Label("Notice how your eyes, attention, and hands feel while you use them.", systemImage: "eye.trianglebadge.exclamationmark")
                        Label("Reflect on how designing for comfort helps more people belong.", systemImage: "person.2.circle")
                    }
                    .font(.body)
                    .foregroundColor(.secondary)
                    .labelStyle(.titleAndIcon)
                }

                VStack(spacing: 16) {
                    NavigationLink {
                        SelectionView()
                    } label: {
                        PrimaryButton(title: "Begin exploring", systemImage: "play.fill")
                    }
                    .accessibilityLabel("Begin exploring experiences")
                    .accessibilityHint("Opens the list of perspectives to try.")

                    Text("No data is collected. This experience stays on your device.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer(minLength: 0)
            }
            .padding()
        }
        .navigationTitle("Welcome")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WelcomeView()
        }
    }
}