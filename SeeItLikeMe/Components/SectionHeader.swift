import SwiftUI
import Foundation

struct SectionHeader: View {
    let title: String
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 8) {
            if let systemImage {
                Image(systemName: systemImage)
                    .imageScale(.medium)
                    .foregroundColor(.accentColor)
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Example", systemImage: "sparkles")
            SectionHeader(title: "Without Icon")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}