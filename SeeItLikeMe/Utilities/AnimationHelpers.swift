import SwiftUI
import Foundation

/// Central place for gentle, safe animations.
enum SafeAnimation {
    /// A slow pulsing animation suitable for background and scale changes.
    static var slowPulsing: Animation {
        .easeInOut(duration: 3.0).repeatForever(autoreverses: true)
    }

    /// A standard ease-in-out used for content transitions.
    static var standard: Animation {
        .easeInOut(duration: 0.3)
    }
}