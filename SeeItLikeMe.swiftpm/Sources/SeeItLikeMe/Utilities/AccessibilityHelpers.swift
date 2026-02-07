import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
enum AccessibilityHelpers {
    static func label(_ text: String) -> some View {
        Text(text)
            .accessibilityLabel(text)
    }
}
