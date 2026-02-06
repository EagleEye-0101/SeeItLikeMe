import SwiftUI
import Foundation

struct FinalReflectionView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SectionHeader(title: "What did you notice?", systemImage: "brain.head.profile")

                Text("""
Small changes in contrast, motion, spacing, and timing changed how comfortable it felt to use each screen. You may have found yourself working harder to read, aim, or stay focused — all without the content ever changing.
""")
                .font(.body)
                .foregroundColor(.primary)

                SectionHeader(title: "Design takeaway", systemImage: "hammer.fill")

                Text("""
Accessible design is not only about adding features. It is about choosing defaults that are gentle on attention and bodies, and offering clear ways to turn down friction when someone needs it.
""")
                .font(.body)
                .foregroundColor(.primary)

                VStack(alignment: .leading, spacing: 8) {
                    SectionHeader(title: "Important note", systemImage: "exclamationmark.triangle.fill")

                    Text("This experience is for awareness only and does not represent medical advice or diagnosis.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("This experience is for awareness only and does not represent medical advice or diagnosis.")
                }

                PrimaryButton(title: "Restart from welcome", systemImage: "arrow.counterclockwise") {
                    // In this simple NavigationStack, dismiss once to go back.
                    // The user can always return to the welcome screen with the back button.
                    dismiss()
                }
                .accessibilityHint("Returns to the previous screen so you can try the experiences again.")

                Spacer(minLength: 0)
            }
            .padding()
        }
        .navigationTitle("Final reflection")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                }
                .accessibilityLabel("Back")
                .accessibilityHint("Go back to the previous screen.")
            }
        }
    }
}

struct FinalReflectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FinalReflectionView()
        }
    }
}