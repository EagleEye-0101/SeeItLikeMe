import SwiftUI
import Foundation

extension View {
    /// Wraps the view in a container that respects Dynamic Type and improves hit targets.
    func paddedHitArea() -> some View {
        self
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
    }

    /// Marks decorative images as hidden from accessibility.
    func decorative() -> some View {
        self.accessibilityHidden(true)
    }
}