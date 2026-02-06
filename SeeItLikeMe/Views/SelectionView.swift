import SwiftUI
import Foundation

struct SelectionView: View {
    private let experiences = AppNavigation.experiences

    var body: some View {
        List {
            Section {
                Text("Choose a perspective to try. Notice how the interface makes you feel, then read the reflection at the bottom of each screen.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .listRowBackground(Color.clear)
            }

            Section {
                ForEach(experiences) { experience in
                    NavigationLink {
                        experience.destination
                            .navigationTitle(experience.title)
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        ExperienceCard(experience: experience)
                    }
                    .accessibilityLabel(experience.title)
                    .accessibilityHint(experience.subtitle)
                }
            } header: {
                SectionHeader(title: "Experiences", systemImage: "circle.grid.2x2")
            }

            Section {
                NavigationLink {
                    FinalReflectionView()
                } label: {
                    HStack {
                        Image(systemName: "lightbulb.led.fill")
                            .foregroundColor(.yellow)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Final reflection")
                                .font(.headline)
                            Text("Summarize what you noticed and how you might design differently.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .accessibilityLabel("Final reflection")
                .accessibilityHint("Read a summary and design takeaways.")
            } header: {
                SectionHeader(title: "Wrap up", systemImage: "checkmark.seal")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Choose a perspective")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectionView()
        }
    }
}