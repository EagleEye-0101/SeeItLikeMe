import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct ExperienceCard: View {
    let experience: ExperienceKind
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: experience.icon)
                    .font(.system(size: 36))
                    .foregroundColor(.accentColor)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(experience.rawValue)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(experience.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(18)
        }
        .buttonStyle(.plain)
    }
}
