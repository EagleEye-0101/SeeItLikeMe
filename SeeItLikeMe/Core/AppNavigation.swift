import SwiftUI
import Foundation

/// Central place to define all available experiences.
enum AppNavigation {
    static let experiences: [Experience] = [
        Experience(
            title: "Visual Strain",
            subtitle: "Explore contrast, size, and brightness.",
            iconName: "eye",
            destination: AnyView(VisualStrainView())
        ),
        Experience(
            title: "Reading Load",
            subtitle: "Feel how subtle movement adds effort.",
            iconName: "textformat",
            destination: AnyView(ReadingLoadView())
        ),
        Experience(
            title: "Motion Sensitivity",
            subtitle: "See how constant motion affects focus.",
            iconName: "waveform.path",
            destination: AnyView(MotionSensitivityView())
        ),
        Experience(
            title: "Interaction Precision",
            subtitle: "Try tapping tiny crowded targets.",
            iconName: "hand.tap",
            destination: AnyView(InteractionPrecisionView())
        )
    ]
}