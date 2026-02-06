import SwiftUI
import Foundation

struct ExperienceCard: View {
    let experience: Experience

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: experience.iconName)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(experience.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(experience.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens the \(experience.title) experience.")
    }
}

struct ExperienceCard_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ExperienceCard(
                experience: Experience(
                    title: "Sample Experience",
                    subtitle: "A short description of what you will feel.",
                    iconName: "sparkles",
                    destination: AnyView(Text("Destination"))
                )
            )
        }
    }
}